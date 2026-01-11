extends Node2D


@export var target_control: Control

const VIEWPORT_SCALE = 2.0


func _process(_delta: float) -> void:
	global_position = get_viewport().get_screen_transform() * get_viewport().get_canvas_transform().affine_inverse() * target_control.global_position / VIEWPORT_SCALE

