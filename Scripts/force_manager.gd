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
		update(normal_force, net_force.y, -PI/2)
		colliding = "U"
		velocity.points[0] = Vector2(velocity.points[0].x, 0)
	else:
		if net_force.x > 0:
			colliding = "L"
			update(normal_force, net_force.x, PI)
		else:
			colliding = "R"
			update(normal_force, net_force.x, PI)
		
		
		velocity.points[1] = Vector2(0, velocity.points[0].y)
		update(normal_force, 0, 0)


func _on_area_2d_area_exited(area: Area2D) -> void:
	colliding = "N"


func update(updated_force: Force, updated_mag: float, updated_ang: float) -> void:
	var net_down: float = 0
	var net_up: float = 0
	var net_left: float = 0
	var net_right: float = 0
	
	var net_force: Vector2 = Vector2(0, 0)
	for f in forces:
		if f == updated_force:
			f.magnitude = updated_mag
			f.angle = updated_ang
			
			f.draw_arrow(PackedVector2Array([Vector2(f.magnitude, 0).rotated(f.angle), Vector2.ZERO]))
		
		net_force += f.points[0]
		
		if f.points[0].x > 0:
			net_right += f.points[0].x
		else:
			net_left += f.points[0].x
		
		if f.points[0].y > 0:
			net_up += f.points[0].y
		else:
			net_down += f.points[0].y
	
	if colliding != "N":
		match colliding:
			"U":
				normal_force.points[0].y = net_down
			"L":
				normal_force.points[0].x = net_left
			"R":
				normal_force.points[0].x = net_right
		
	
	net_force /= mass
	
	acceleration.magnitude = net_force.length()
	acceleration.angle = net_force.angle()
	
	acceleration.draw_arrow(PackedVector2Array([net_force, Vector2.ZERO]))

