extends Node2D


func _process(_delta: float) -> void:
	print(global_position)


func _unhandled_input(event):
	if event is InputEventMouse:
		global_position = get_viewport().get_screen_transform() * get_viewport().get_canvas_transform().affine_inverse() * event.position
