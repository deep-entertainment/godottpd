# A base class for all HTTP routers
extends RefCounted
class_name HttpRouter


# Handle a GET request
func handle_get(request: HttpRequest, response: HttpResponse) -> void:
	response.send(405, "GET not allowed")

# Handle a POST request
func handle_post(request: HttpRequest, response: HttpResponse) -> void:
	response.send(405, "POST not allowed")

# Handle a HEAD request
func handle_head(request: HttpRequest, response: HttpResponse) -> void:
	response.send(405, "HEAD not allowed")

# Handle a PUT request
func handle_put(request: HttpRequest, response: HttpResponse) -> void:
	response.send(405, "PUT not allowed")

# Handle a PATCH request
func handle_patch(request: HttpRequest, response: HttpResponse) -> void:
	response.send(405, "PATCH not allowed")

# Handle a DELETE request
func handle_delete(request: HttpRequest, response: HttpResponse) -> void:
	response.send(405, "DELETE not allowed")
	
# Handle an OPTIONS request
func handle_options(request: HttpRequest, response: HttpResponse) -> void:
	response.send(405, "OPTIONS not allowed")
