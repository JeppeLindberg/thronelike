extends Node2D


@onready var main = get_node('/root/main')
@onready var world = get_node('/root/main/world')


var initialized = false


func _process(_delta: float) -> void:
	if not initialized:
		if get_parent() == world:
			var new_ground_item = main.ground_item_prefab.instantiate()
			world.add_child(new_ground_item)
			new_ground_item.global_position = global_position
			new_ground_item.add_item(self)
			initialized = true





