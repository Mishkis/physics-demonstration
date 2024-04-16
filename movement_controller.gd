extends Node

@export var force_manager: Node2D

@export var up_force: Force
@export var left_force: Force
@export var friction_force: Force

@export var camera: Camera2D

@export var train: PackedScene

var force: int

func _unhandled_input(event: InputEvent) -> void:
	match event.as_text():
		"W":
			force_manager.update(up_force, force, -PI/2)
		"S":
			force_manager.update(up_force, force, PI/2)
		"A":
			force_manager.mew = 0.8
			force_manager.stationary = false
			force_manager.update(left_force, force, PI)
			if force_manager.colliding == "U":
				force_manager.update(friction_force, friction_force.magnitude, 0)
		"D":
			if force != 10:
				force_manager.mew = 0.8
			force_manager.stationary = false
			force_manager.update(left_force, force, 0)
			if force_manager.colliding == "U":
				force_manager.update(friction_force, friction_force.magnitude, PI)
		"Minus":
			camera.zoom += Vector2.ONE * -0.1
		"Equal":
			camera.zoom += Vector2.ONE * 0.1
		"Escape":
			force_manager.stationary = true
			force_manager.update(up_force, 0, 0)
			force_manager.update(left_force, 0, 0)
			force_manager.mew = 1.02
			
			if force_manager.colliding == "U":
				force_manager.update(friction_force, 0, 0)
				force_manager.velocity.points[0] = Vector2(0, 0)
				force_manager.acceleration.points[0] = Vector2(0, 0)
		"1":
			force = 10
		"2":
			force = 20
		"3":
			force = 30
		"4":
			force = 40
		"5":
			force = 50
		"6":
			force = 60
		"7":
			force = 70
		"8":
			force = 80
		"9":
			force = 90
		"Space":
			get_tree().change_scene_to_file("res://Scenes/train.tscn")
