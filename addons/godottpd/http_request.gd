# An HTTP request received by the server
extends Reference
class_name HttpRequest


# A dictionary of the headers of the request
var headers: Dictionary

# The received raw body
var body: String

# A match object of the regular expression that matches the path
var query_match: RegExMatch

# The path that matches the router path
var path: String

# The method
var method: String

# A dictionary of request (aka. routing) parameters
var parameters: Dictionary

# A dictionary of request query parameters
var query: Dictionary

# Override `str()` method, automatically called in `print()` function
func _to_string() -> String:
    return JSON.print({headers=headers, method=method, path=path})