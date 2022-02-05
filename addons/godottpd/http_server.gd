# A routable HTTP server for Godot
extends Node
class_name HttpServer

# If debug messages should be printed in console on requests
var _debug: bool = false

# The ip address to bind the server to. Use * for all IP addresses [*]
var bind_address: String = "*"

# The port to bind the server to. [8080]
var port: int = 8080

# The server identifier to use when responding to requests [GodotTPD]
var server_identifier: String = "GodotTPD"


# The TCP server instance used
var _server: TCP_Server

# An array of StraemPeerTCP objects who are currently talking to the server
var _clients: Array

# A list of HttpRequest routers who could handle a request
var _routers: Array = []

# A regex identifiying the method line
var _method_regex: RegEx = RegEx.new()

# A regex for header lines
var _header_regex: RegEx = RegEx.new()

# The base path used in a project to serve files
var _local_base_path: String = "res://src"

# Compile the required regex
func _init(_debug: bool = false) -> void:
	self._debug = _debug
	_method_regex.compile("^(?<method>GET|POST|HEAD|PUT|PATCH|DELETE|OPTIONS) (?<path>[^ ]+) HTTP/1.1$")
	_header_regex.compile("^(?<key>[^:]+): (?<value>.+)$")

# Print a debug message in console, if the debug mode is enabled
func _print_debug(message: String) -> void:
	if _debug:
		var time = OS.get_datetime()
		var time_return = "%02d-%02d-%02d %02d:%02d:%02d" % [time.year, time.month, time.day, time.hour, time.minute, time.second]
		print("[SERVER] ",time_return," >> ", message)

# Register a new router to handle a specific path
#
# #### Parameters
# - path: The path the router will handle. Supports a regular expression and the
#   group matches will be available in HttpRequest.query_match.
# - router: The HttpRouter that will handle the request
func register_router(path: String, router: HttpRouter):
	var path_regex = RegEx.new()
	var params: Array = []
	if path.left(0) == "^":
		path_regex.compile(path)
	else:
		var regexp: Array = _path_to_regexp(path)
		path_regex.compile(regexp[0])
		params = regexp[1]
	_routers.push_back({
		"path": path_regex,
		"params": params,
		"router": router
	})


# Handle possibly incoming requests
func _process(_delta: float) -> void:
	if _server:
		var new_client = _server.take_connection()
		if new_client:
			self._clients.append(new_client)
		for client in self._clients:
			if client.get_status() == StreamPeerTCP.STATUS_CONNECTED:
				var bytes = client.get_available_bytes()
				if bytes > 0:
					var request_string = client.get_string(bytes)
					self._handle_request(client, request_string)


# Start the server
func start():
	self._server = TCP_Server.new()
	self._server.listen(self.port, self.bind_address)
	_print_debug("Server listening on http://%s:%s" % [self.bind_address, self.port])


# Stop the server and disconnect all clients
func stop():
	for client in self._clients:
		client.disconnect_from_host()
	self._clients.clear()
	self._server.stop()
	_print_debug("Server stopped.")
	

# Interpret a request string and perform the request
#
# #### Parameters
# - client: The client that send the request
# - request: The received request 
func _handle_request(client: StreamPeer, request_string: String):
	var request = HttpRequest.new()
	for line in request_string.split("\r\n"):
		var method_matches = _method_regex.search(line)
		var header_matches = _header_regex.search(line)
		if method_matches:
			request.method = method_matches.get_string("method")
			request.path = method_matches.get_string("path")
			request.headers = {}
			request.body = ""
		elif header_matches:
			request.headers[header_matches.get_string("key")] = \
			header_matches.get_string("value")
		else:
			request.body += line
	self._perform_current_request(client, request)


# Handle a specific request and send it to a router
# If no router matches, send a 404
#
# #### Parameters
# - client: The client that send the request
# - request_info: A dictionary with information about the request
#   - method: The method of the request (e.g. GET, POST)
#   - path: The requested path
#   - headers: A dictionary of headers of the request
#   - body: The raw body of the request
func _perform_current_request(client: StreamPeer, request: HttpRequest):
	_print_debug("HTTP Request: " + str(request))
	var found = false
	var response = HttpResponse.new()
	response.client = client
	response.server_identifier = server_identifier
	for router in self._routers:
		var matches = router.path.search(request.path)
		if matches:
			request.query_match = matches
			if router.params.size() > 0:
				for parameter in router.params:
					request.parameters[parameter] = request.query_match.get_string(parameter)
			match request.method:
				"GET":
					found = true
					router.router.handle_get(request, response)
				"POST":
					found = true
					router.router.handle_post(request, response)
				"HEAD":
					found = true
					router.router.handle_head(request, response)
				"PUT":
					found = true
					router.router.handle_put(request, response)
				"PATCH":
					found = true
					router.router.handle_patch(request, response)
				"DELETE":
					found = true
					router.router.handle_delete(request, response)
				"OPTIONS":
					found = true
					router.router.handle_options(request, response)
	if not found:
		if not request.path.get_extension() in ["gd"]:
			var content: String = serve_file(request)
			if content != "":
				found = true
				response.send(200, content, "text/"+request.path.get_extension())
	if not found:	
		response.send(404, "Not found")

# Serve a file in the local system.
# Files to be exposed are only rooted from the @_local_base_path for security
func serve_file(request: HttpRequest) -> String:
	var content: String = ""
	var file = File.new()
	var file_opened: bool = not bool(file.open(_local_base_path+"/"+request.path, File.READ))
	if file_opened:
		content = file.get_as_text()
		file.close()
	return content


# Converts a URL path to @regexp RegExp, providing a mechanism to fetch groups from the expression
# indexing each parameter by name in the @params array
#
# @regexp --> the output expression as a String, to be compiled in RegExp
# @params --> an Array of parameters, indexed by names. Can be fetched using `RegExp.get_string()` method
# ex. "/user/:id" --> "^/user/(?<id>([^/#?]+?))[/#?]?$"
func _path_to_regexp(path: String) -> Array:
	var regexp: String = "^"
	var params: Array = []
	var fragments: Array = path.split("/")
	fragments.pop_front()
	for fragment in fragments:
		if fragment.left(1) == ":":
			fragment = fragment.lstrip(":")
			regexp+="/(?<%s>([^/#?]+?))"%fragment
			params.append(fragment)
		else:
			regexp+="/"+fragment
	regexp+="[/#?]?$"
	return [regexp, params]