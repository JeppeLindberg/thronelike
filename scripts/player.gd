extends CharacterBody2D


@onready var main = get_node('/root/main')

@export var mouse_follower: Node2D
@export var ui_weapon_1: Node2D
@export var ui_weapon_2: Node2D
@export_flags_2d_physics var ground_item_layer

@export var starting_weapon: PackedScene

@export var ground_item_scanner: CollisionShape2D



var input_dir = Vector2.ZERO
var input_shooting = false
var input_pick_up = false
var move_direction = Vector2.ZERO
var bullet_timer = 0.0
var current_ground_item = null
var weapon_1 = null
var weapon_2 = null
var current_weapon_index = 0

const SPEED = 50.0
const ACCEL = 1000.0



func _ready() -> void:
	var weapon = starting_weapon.instantiate()
	pick_up_weapon(weapon)
	weapon_1 = weapon
	current_weapon_index = 1

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
	var current_weapon = null
	if current_weapon_index == 1:
		current_weapon = weapon_1
	elif current_weapon_index == 2:
		current_weapon = weapon_2
	else:
		return

	current_weapon.shooting = input_shooting
	current_weapon.handle_shooting(self, delta)		

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


func pick_up_weapon(weapon):
	if weapon_1 == null:
		if weapon.get_parent():
			weapon.reparent(ui_weapon_1)
		else:
			ui_weapon_1.add_child(weapon)
		weapon_1 = weapon
		current_weapon_index = 1

	elif weapon_2 == null:
		if weapon.get_parent():
			weapon.reparent(ui_weapon_2)
		else:
			ui_weapon_2.add_child(weapon)
		weapon_2 = weapon
		current_weapon_index = 2

	else:
		print('DROP CURRENT WEAPON')
	
	weapon.position = Vector2.ZERO
		
