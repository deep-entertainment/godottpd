<!-- Auto-generated from JSON by GDScript docs maker. Do not edit this document directly. -->

# HttpResponse

**Extends:** [Object](../Object)

## Description

A response object useful to send out responses

## Property Descriptions

### client

```gdscript
var client: StreamPeer
```

The client currently talking to the server

### server\_identifier

```gdscript
var server_identifier: String = "GodotTPD"
```

The server identifier to use on responses [GodotTPD]

## Method Descriptions

### send

```gdscript
func send(status: int, data: String, content_type: String = "text/html") -> void
```

Send out a response to the client

#### Parameters
- status: The HTTP status code to send
- data: The body data to send
- content_type: The type of the content to send