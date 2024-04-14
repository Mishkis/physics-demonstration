class_name Force
extends Line2D

@export var text_display: Label
@export var force_name: String
@export var magnitude: float
@export_range(-PI, PI, 0.001) var angle: float
@export var color: Color

func draw_arrow(pointArray: PackedVector2Array) -> void:
	points = pointArray
	modulate = color
	
	text_display.position = points[0] + Vector2(0, 20).rotated(angle)
	text_display.text = force_name
