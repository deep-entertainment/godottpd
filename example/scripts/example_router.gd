extends HttpRouter
class_name MyExampleRouter

# Handle a GET request
func handle_get(request: HttpRequest, response: HttpResponse):
	response.send(200, "Hello! from GET")

# Handle a POST request
func handle_post(request: HttpRequest, response: HttpResponse) -> void:
	print_debug(">>>>>>>The body: %s" % request.body)
	response.send(200, "Hello! from POST")

# Handle a PUT request
func handle_put(request: HttpRequest, response: HttpResponse) -> void:
	response.send(200, "Hello! from PUT")

# Handle a PATCH request
func handle_patch(request: HttpRequest, response: HttpResponse) -> void:
	response.send(200, "Hello! from PATCH")

# Handle a DELETE request
func handle_delete(request: HttpRequest, response: HttpResponse) -> void:
	response.send(200, "Hello! from DELETE")
