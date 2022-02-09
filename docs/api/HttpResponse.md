<!-- Auto-generated from JSON by GDScript docs maker. Do not edit this document directly. -->

# HttpResponse

**Extends:** [Reference](../Reference)

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

### headers

```gdscript
var headers: Dictionary
```

A dictionary of headers
Headers can be set using the `set(name, value)` function

### cookies

```gdscript
var cookies: Array
```

An array of cookies
Cookies can be set using the `cookie(name, value, options)` function
Cookies will be automatically sent via "Set-Cookie" headers to clients

## Method Descriptions

### send\_raw

```gdscript
func send_raw(status_code: int, data: PoolByteArray, content_type: String = "application/octet-stream") -> void
```

Send out a raw (Bytes) response to the client
Useful to send files faster or raw data which will be converted by the client

#### Parameters
- status: The HTTP status code to send
- data: The body data to send []
- content_type: The type of the content to send ["text/html"]

### send

```gdscript
func send(status_code: int, data: String = "", content_type = "text/html") -> void
```

Send out a response to the client

#### Parameters
- status: The HTTP status code to send
- data: The body data to send []
- content_type: The type of the content to send ["text/html"]

### json

```gdscript
func json(status_code: int, data) -> void
```

Send out a JSON response to the client
This function will internally call the `send()` method

#### Parameters
- status_code: The HTTP status code to send
- data: The body data to send, must be a Dictionary or an Array

### set

```gdscript
func set(field: String, value: String) -> void
```

Sets the response’s header "field" to "value"

#### Parameters
- field: the name of the header i.e. "Accept-Type"
- value: the value of this header i.e. "application/json"

### cookie

```gdscript
func cookie(name: String, value: String, options: Dictionary) -> void
```

Sets cookie "name" to "value"

#### Parameters
- name: the name of the cookie i.e. "user-id"
- value: the value of this cookie i.e. "abcdef"
- options: a Dictionary of ![cookie attributes](https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/Set-Cookie#attributes)
			 for this specific cookie, in the { "secure" : "true" } format