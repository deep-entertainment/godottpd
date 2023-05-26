extends HttpRouter
class_name MyExampleRouter

# Handle a GET request
func handle_get(request: HttpRequest, response: HttpResponse):
	response.send(200, "Hello! from GET")

# Handle a POST request
func handle_post(request: HttpRequest, response: HttpResponse) -> void:
	response.send(200, JSON.stringify({
		message = "Hello! from POST",
		raw_body = request.body,
		parsed_body = request.get_body_parsed(),
		params = request.query
	}), "application/json")

# Handle a PUT request
func handle_put(request: HttpRequest, response: HttpResponse) -> void:
	response.send(200, "Hello! from PUT")

# Handle a PATCH request
func handle_patch(request: HttpRequest, response: HttpResponse) -> void:
	response.send(200, "Hello! from PATCH")

# Handle a DELETE request
func handle_delete(request: HttpRequest, response: HttpResponse) -> void:
	response.send(200, "Hello! from DELETE")
