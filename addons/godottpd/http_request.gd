# An HTTP request received by the server
extends Object
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

# Parameters
var parameters: Dictionary


func _to_string() -> String:
    return "[headers=%s, method='%s', path='%s']" % [headers, method, path]