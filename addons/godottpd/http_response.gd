# A response object useful to send out responses
extends Object
class_name HttpResponse


# The client currently talking to the server
var client: StreamPeer

# The server identifier to use on responses [GodotTPD]
var server_identifier: String = "GodotTPD"


# Send out a response to the client
#
# #### Parameters
# - status: The HTTP status code to send
# - data: The body data to send
# - content_type: The type of the content to send
func send(status: int, data: String, content_type: String = "text/html") -> void:
	client.put_data(("HTTP/1.1 %d OK\n" % status).to_ascii())
	client.put_data(("Server: %s\n" % server_identifier).to_ascii())
	client.put_data(("Content-Length: %d\n" % data.to_ascii().size()).to_ascii())
	client.put_data("Connection: close\n".to_ascii())
	client.put_data(("Content-Type: %s\n\n" % content_type).to_ascii())
	client.put_data(data.to_ascii())
