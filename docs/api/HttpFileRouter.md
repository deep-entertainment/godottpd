<!-- Auto-generated from JSON by GDScript docs maker. Do not edit this document directly. -->

# HttpFileRouter

**Extends:** [HttpRouter](../HttpRouter) < [Reference](../Reference)

## Description

Class inheriting HttpRouter for handling file serving requests

## Property Descriptions

### path

```gdscript
var path: String = ""
```

Full path to the folder which will be exposed to web

### fallback\_page

```gdscript
var fallback_page: String = ""
```

Full path to the fallback page which will be served if the requested file was not found

### extensions

```gdscript
var extensions: PoolStringArray
```

An ordered list of extensions that will be checked
if no file extension is provided by the request

### exclude\_extensions

```gdscript
var exclude_extensions: PoolStringArray
```

A list of extensions that will be excluded if requested

## Method Descriptions

### \_init

```gdscript
func _init(path: String, options: Dictionary) -> void
```

### handle\_get

```gdscript
func handle_get(request: HttpRequest, response: HttpResponse) -> void
```

Handle a GET request