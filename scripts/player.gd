extends CharacterBody2D

@export var mouse_follower: Node2D

@export var bullets_per_second = 3.0

@export var bullet_prefab: PackedScene



var input_dir = Vector2.ZERO
var move_direction = Vector2.ZERO
var input_shooting = false
var bullet_timer = 0.0


const SPEED = 10.0
const ACCEL = 50.0



func _physics_process(delta: float) -> void:
	_handle_input()

	_handle_shooting(delta)

	_handle_movement(delta)

	move_and_slide()

func _handle_input():
	input_dir = Input.get_vector("left", "right", "up", "down")
	move_direction = input_dir.normalized()
	input_shooting = Input.is_action_pressed('shoot')

func _handle_shooting(delta):
	bullet_timer += bullets_per_second * delta

	if input_shooting == true:
		if bullet_timer > 1.0:
			var new_bullet = bullet_prefab.instantiate()
			get_parent().add_child(new_bullet)
			new_bullet.global_position = global_position
			new_bullet.move_direction = (mouse_follower.global_position - global_position).normalized()
			bullet_timer -= 1.0
	
	if bullet_timer > 1.0:
		bullet_timer = 1.0
		

func _handle_movement(delta):
	var calculated_speed = SPEED

	var target_velocity = move_direction * calculated_speed
	
	velocity = velocity.move_toward(target_velocity, delta * ACCEL)
