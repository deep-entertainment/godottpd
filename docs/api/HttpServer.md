<!-- Auto-generated from JSON by GDScript docs maker. Do not edit this document directly. -->

# HttpServer

**Extends:** [Node](../Node)

## Description

A routable HTTP server for Godot

## Property Descriptions

### bind\_address

```gdscript
var bind_address: String = "*"
```

The ip address to bind the server to. Use * for all IP addresses [*]

### port

```gdscript
var port: int = 8080
```

The port to bind the server to. [8080]

### server\_identifier

```gdscript
var server_identifier: String = "GodotTPD"
```

The server identifier to use when responding to requests [GodotTPD]

## Method Descriptions

### \_init

```gdscript
func _init(_logging: bool = false) -> void
```

Compile the required regex

### register\_router

```gdscript
func register_router(path: String, router: HttpRouter)
```

Register a new router to handle a specific path

#### Parameters
- path: The path the router will handle. Supports a regular expression and the
  group matches will be available in HttpRequest.query_match.
- router: The HttpRouter that will handle the request

### start

```gdscript
func start()
```

Start the server

### stop

```gdscript
func stop()
```

Stop the server and disconnect all clients