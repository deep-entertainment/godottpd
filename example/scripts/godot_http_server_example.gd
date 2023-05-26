extends Node


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var server = HttpServer.new()
	server.register_router("/", MyExampleRouter.new())
	add_child(server)
	server.start()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
