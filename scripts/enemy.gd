extends CharacterBody2D

var player: Node2D

@export var bullets_per_second = 3.0

@export var bullet_prefab: PackedScene



var move_direction = Vector2.ZERO
var shooting = false
var bullet_timer = 0.0

var lifetime = 0.0
var next_change_direction = 0.0


const SPEED = 10.0
const ACCEL = 50.0



func _ready() -> void:
	player = get_node('/root/main/world/player')


func _physics_process(delta: float) -> void:

	_handle_shooting(delta)

	_handle_movement(delta)

	move_and_slide()

func _handle_shooting(delta):
	bullet_timer += bullets_per_second * delta

	if shooting == true:
		if bullet_timer > 1.0:
			var new_bullet = bullet_prefab.instantiate()
			get_parent().add_child(new_bullet)
			new_bullet.global_position = global_position
			new_bullet.move_direction = (player.global_position - global_position).normalized()
			bullet_timer -= 1.0
	
	if bullet_timer > 1.0:
		bullet_timer = 1.0
		

func _handle_movement(delta):
	lifetime += delta

	if next_change_direction < lifetime:
		next_change_direction += 1
		move_direction = Vector2.UP.rotated(randf_range(0.0, deg_to_rad(360.0)))

	var calculated_speed = SPEED

	var target_velocity = move_direction * calculated_speed
	
	velocity = velocity.move_toward(target_velocity, delta * ACCEL)
