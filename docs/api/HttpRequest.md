<!-- Auto-generated from JSON by GDScript docs maker. Do not edit this document directly. -->

# HttpRequest

**Extends:** [Reference](../Reference)

## Description

An HTTP request received by the server

## Property Descriptions

### headers

```gdscript
var headers: Dictionary
```

A dictionary of the headers of the request

### body

```gdscript
var body: String
```

The received raw body

### query\_match

```gdscript
var query_match: RegExMatch
```

A match object of the regular expression that matches the path

### path

```gdscript
var path: String
```

The path that matches the router path

### method

```gdscript
var method: String
```

The method

### parameters

```gdscript
var parameters: Dictionary
```

A dictionary of request (aka. routing) parameters

### query

```gdscript
var query: Dictionary
```

A dictionary of request query parameters