# A routable HTTP server for Godot
extends Node
class_name HttpServer


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


# Compile the required regex
func _init() -> void:
	_method_regex.compile("^(?<method>GET|POST|HEAD|PUT|PATCH|DELETE|OPTIONS) (?<path>[^ ]+) HTTP/1.1$")
	_header_regex.compile("^(?<key>[^:]+): (?<value>.+)$")


# Register a new router to handle a specific path
#
# #### Parameters
# - path: The path the router will handle. Supports a regular expression and the
#   group matches will be available in HttpRequest.query_match.
# - router: The HttpRouter that will handle the request
func register_router(path: String, router: HttpRouter):
	var path_regex = RegEx.new()
	path_regex.compile(path)
	_routers.push_back({
		"path": path_regex,
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


# Stop the server and disconnect all clients
func stop():
	for client in self._clients:
		client.disconnect_from_host()
	self._clients.clear()
	self._server.stop()
	

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
	var found = false
	var response = HttpResponse.new()
	response.client = client
	response.server_identifier = server_identifier
	for router in self._routers:
		var matches = router.path.search(request.path)
		if matches:
			request.query_match = matches
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
		response.send(404, "Not found")
