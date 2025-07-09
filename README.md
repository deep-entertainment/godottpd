> [!IMPORTANT]
> This repository is deprecated. Please see the fork https://github.com/bit-garden/godottpd for the current version.

# GodotTPD

A routeable HTTP server for Godot.

This addon for the [Godot engine](https://godotengine.com) includes classes to start an HTTP server which can handle requests to paths using a set of routers in the way [ExpressJS](https://expressjs.com/) works.

## Basic workflow

Create a router class that extends [HttpRouter](HttpRouter.md). Overwrite the methods that handle the required HTTP methods required for the specific path:

```python
extends HttpRouter
class_name MyExampleRouter


func handle_get(request, response):
	response.send(200, "Hello!")

```

This router would respond to a GET [request](HttpRequest.md) on its path and send back a [response](HttpResponse.md) with a 200 status code and the body "Hello!".

Afterwards, create a new [HttpServer](HttpServer.md), add the router and start the server. This needs to be called from a node in the SceneTree.

```python
var server = HttpServer.new()
server.register_router("/", MyExampleRouter.new())
add_child(server)
server.start()
```

## Documentation

Further information can be found in the API documentation:

- [HttpRequest](docs/api/HttpRequest.md)
- [HttpResponse](docs/api/HttpResponse.md)
- [HttpRouter](docs/api/HttpRouter.md)
- [HttpServer](docs/api/HttpServer.md)
- [HttpFileRouter](docs/api/HttpFileRouter.md)

## Issues and feature requests

Please check out the [deep entertainment issue repository](https://github.com/deep-entertainment/issues/issues) if you find bugs or have ideas for new features.
