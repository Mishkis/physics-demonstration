extends Force

@export var object: Node2D

@export var normal_force: Force


func _physics_process(delta: float) -> void:
	object.position += points[0] * delta
