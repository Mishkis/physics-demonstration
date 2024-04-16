extends Node

@export var mass: float

@export var velocity: Force
@export var acceleration: Force

@export var normal_force: Force

@export var friction_force: Force

@export var forces: Array[Force]

# "N" for none, "U" for up, "L" for left, "R" for right.
var colliding: String = "N"

func _ready() -> void:
	for f in forces:
		update(f, f.magnitude, f.angle)


func _on_area_2d_area_entered(area: Area2D) -> void:
	var collision_size: Vector2 = area.get_node("CollisionShape2D").shape.get_rect().size
	
	var net_force: Vector2 = Vector2(0, 0)
	for f in forces:
		net_force += f.points[0]
	
	if collision_size[0] > collision_size[1]:
		colliding = "U"
		update(normal_force, net_force.y, -PI/2)
		velocity.points[0] = Vector2(velocity.points[0].x, 0)
	else:
		if net_force.x > 0:
			colliding = "R"
			update(normal_force, net_force.x, 0)
		else:
			colliding = "L"
			update(normal_force, net_force.x, PI)
		
		velocity.points[0] = Vector2(0, velocity.points[0].y)


func _on_area_2d_area_exited(area: Area2D) -> void:
	colliding = "N"
	update(normal_force, 0, 0)
	update(friction_force, 0, 0)


func update(updated_force: Force, updated_mag: float, updated_ang: float) -> void:
	if colliding == "N":
		normal_force.points[0] = Vector2(0, 0)
		friction_force.points[0] = Vector2(0, 0)
	var net_force: Vector2 = Vector2(0, 0)
	for f in forces:
		if f == updated_force:
			f.magnitude = updated_mag
			f.angle = updated_ang
			
			f.draw_arrow(PackedVector2Array([Vector2(f.magnitude, 0).rotated(f.angle), Vector2.ZERO]))
		
		net_force += f.points[0]
	
	if colliding != "N":
		match colliding:
			"U":
				if not (-0.001 <= net_force.y and net_force.y <= 0.001):
					update(normal_force, min(0, normal_force.magnitude - net_force.y), -PI/2)
				
				var friction_coefficent: float = 0.2 * normal_force.magnitude
				if -friction_force.points[0].x != friction_coefficent:
					update(friction_force, friction_coefficent, 0 if net_force.x < 0 else PI)
				
				if normal_force.points[0].y != 0:
					net_force.y = 0
				net_force += friction_force.points[0]
			"L":
				if not (-0.001 <= net_force.x and net_force.x <= 0.001):
					update(normal_force, normal_force.magnitude - net_force.x, 0)
				
				var friction_coefficent: float = 0.2 * normal_force.magnitude
				var diff: float = friction_coefficent + friction_force.points[0].y
				
				if not (-0.001 <= diff and diff <= 0.001):
					update(friction_force, friction_coefficent, -PI/2)
				
				if normal_force.points[0].x != 0:
					net_force.x = 0
				net_force += friction_force.points[0]
			"R":
				if not (-0.001 <= net_force.x and net_force.x <= 0.001):
					update(normal_force, normal_force.magnitude + net_force.x, PI)
				
				var friction_coefficent: float = 0.2 * normal_force.magnitude
				var diff: float = friction_coefficent + friction_force.points[0].y
				if not (-0.001 <= diff and diff <= 0.001):
					update(friction_force, friction_coefficent, -PI/2)
				
				if normal_force.points[0].x != 0:
					net_force.x = 0
				net_force += friction_force.points[0]
	
	net_force /= mass
	
	acceleration.magnitude = net_force.length()
	acceleration.angle = net_force.angle()
	
	acceleration.draw_arrow(PackedVector2Array([net_force, Vector2.ZERO]))

