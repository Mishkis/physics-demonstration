class_name Force
extends Line2D

@export var pivot_point: Node2D
@export var text_display: Label

@export var force_name: String
@export var magnitude: float
@export_range(-PI, PI, 0.001) var angle: float
@export var color: Color

func draw_arrow(pointArray: PackedVector2Array) -> void:
	if magnitude > 0:
		show()
		
		points = pointArray
		modulate = color
		
		pivot_point.position = pointArray[0] + Vector2(20, 0).rotated(angle)
		text_display.text = force_name
	else:
		hide()
