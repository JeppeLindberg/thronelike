extends CharacterBody2D


@onready var main = get_node('/root/main')

@export var mouse_follower: Node2D
@export_flags_2d_physics var ground_item_layer

@export var bullets_per_second = 3.0

@export var bullet_prefab: PackedScene
@export var ground_item_scanner: CollisionShape2D



var input_dir = Vector2.ZERO
var input_shooting = false
var input_pick_up = false
var move_direction = Vector2.ZERO
var bullet_timer = 0.0
var current_ground_item = null

const SPEED = 50.0
const ACCEL = 1000.0



func _physics_process(delta: float) -> void:
	_handle_input()

	_handle_shooting(delta)

	_handle_movement(delta)

	_handle_ground_item()

	move_and_slide()

func _handle_input():
	input_dir = Input.get_vector("left", "right", "up", "down")
	move_direction = input_dir.normalized()
	input_shooting = Input.is_action_pressed('shoot')
	input_pick_up = Input.is_action_just_pressed('pick_up')

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

func _handle_ground_item():
	var items = main.get_nodes_in_shape(ground_item_scanner, ground_item_layer)
	if items == []:
		_set_current_ground_item(null)
		return
	
	var greatest_dist = 9999.0
	var target_item = items[0]
	for item in items:
		if item.global_position.distance_to(global_position) < greatest_dist:
			target_item = item
			greatest_dist = item.global_position.distance_to(global_position)
	
	_set_current_ground_item(target_item)

	if input_pick_up and current_ground_item != null:
		current_ground_item.pick_up(self)

func _set_current_ground_item(new_target):
	if current_ground_item != new_target and current_ground_item != null:
		current_ground_item.display_pick_up_possible = false
	current_ground_item = new_target
	if current_ground_item != null:
		current_ground_item.display_pick_up_possible = true


		
