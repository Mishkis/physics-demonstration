extends Force

@export var velocity: Force

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var new_point: Vector2 = velocity.points[0] + points[0] * delta
	
	velocity.magnitude = new_point.length()
	velocity.angle = new_point.angle()
	
	velocity.draw_arrow(PackedVector2Array([new_point, Vector2.ZERO]))
