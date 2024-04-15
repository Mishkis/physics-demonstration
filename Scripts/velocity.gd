extends Force

@export var object: Node2D

func _process(delta: float) -> void:
	object.position += points[0] * delta
