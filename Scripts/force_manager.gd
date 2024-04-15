extends Node

@export var mass: float

@export var acceleration: Force

@export var forces: Array[Force]

func _ready() -> void:
	for f in forces:
		update(f, f.magnitude, f.angle)

func update(updated_force: Force, updated_mag: float, updated_ang: float) -> void:
	var net_force: Vector2 = Vector2(0, 0)
	for f in forces:
		if f == updated_force:
			f.magnitude = updated_mag
			f.angle = updated_ang
			
			f.draw_arrow(PackedVector2Array([Vector2(f.magnitude, 0).rotated(f.angle), Vector2.ZERO]))
		
		net_force += Vector2(f.magnitude, 0).rotated(f.angle)
	
	net_force /= mass
	
	acceleration.magnitude = net_force.length()
	acceleration.angle = net_force.angle()
	
	acceleration.draw_arrow(PackedVector2Array([net_force, Vector2.ZERO]))
