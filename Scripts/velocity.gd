extends Force

@export var object: Node2D

@export var normal_force: Force


func _physics_process(delta: float) -> void:
	object.position += points[0] * delta


func _on_area_2d_area_entered(area: Area2D) -> void:
	print(area.get_child(0)
