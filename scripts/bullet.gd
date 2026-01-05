extends RigidBody2D


@export var speed = 150.0

var move_direction = Vector2.ZERO


func _physics_process(delta: float) -> void:
	_handle_movement(delta)

func _handle_movement(_delta):
	var calculated_speed = speed

	var target_velocity = move_direction * calculated_speed
	
	linear_velocity = target_velocity 
	






