extends Node2D


@onready var main = get_node('/root/main')
@onready var world = get_node('/root/main/world')
@onready var mouse_follower = get_node('/root/main/mouse_follower')

@export var bullets_per_second = 3.0

@export var bullet_prefab: PackedScene


var initialized = false
var shooting = false
var bullet_timer = 0.0


func pick_up(player):
	player.pick_up_weapon(self)

func _process(_delta: float) -> void:
	if not initialized:
		if get_parent() == world:
			var new_ground_item = main.ground_item_prefab.instantiate()
			world.add_child(new_ground_item)
			new_ground_item.global_position = global_position
			new_ground_item.add_item(self)
			initialized = true


func handle_shooting(player, delta):
	bullet_timer += bullets_per_second * delta

	if shooting == true:
		if bullet_timer > 1.0:
			var new_bullet = bullet_prefab.instantiate()
			get_parent().add_child(new_bullet)
			new_bullet.global_position = player.global_position
			new_bullet.move_direction = (mouse_follower.global_position - player.global_position).normalized()
			bullet_timer -= 1.0
	
	if bullet_timer > 1.0:
		bullet_timer = 1.0



