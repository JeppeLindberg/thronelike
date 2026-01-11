extends Node2D


@onready var main = get_node('/root/main')
@onready var world = get_node('/root/main/world')
@onready var mouse_follower = get_node('/root/main/mouse_follower')
@onready var ui_visual = get_node('ui_visual')
@onready var ground_item_visual = get_node('ground_item_visual')
@onready var reload_progress = get_node('ui_visual/reload_progress')

@export var bullets_per_second = 3.0

@export var bullet_prefab: PackedScene


var initialized = false
var is_current_weapon = false
var shooting = false
var bullet_timer = 0.0


func pick_up(player):
	player.pick_up_weapon(self)
	ui_visual.visible = true
	ground_item_visual.visible = false

func turn_to_ground_item(new_position, _new_velocity = Vector2.ZERO):
	var new_ground_item = main.ground_item_prefab.instantiate()
	world.add_child(new_ground_item)
	new_ground_item.global_position = new_position
	new_ground_item.add_item(self)
	ui_visual.visible = false
	ground_item_visual.visible = true

	initialized = true

func _process(_delta: float) -> void:
	if not initialized:
		if get_parent() == world:
			turn_to_ground_item(global_position)

func handle_shooting(player, delta):
	bullet_timer += bullets_per_second * delta

	reload_progress.text = str(clampf(roundf(bullet_timer * 10.0)/10.0, 0.0, 1.0))

	if shooting == true:
		if bullet_timer > 1.0:
			var new_bullet = bullet_prefab.instantiate()
			get_parent().add_child(new_bullet)
			new_bullet.global_position = player.global_position
			new_bullet.move_direction = (mouse_follower.global_position - player.global_position).normalized()
			bullet_timer -= 1.0
	
	if bullet_timer > 1.0:
		bullet_timer = 1.0



