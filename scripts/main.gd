extends Node

@export var ground_item_prefab: PackedScene

@onready var world = get_node('/root/main/world')


func get_nodes_in_shape(shape, collision_mask = 0, motion = Vector2.ZERO):
	var temp_shape = PhysicsShapeQueryParameters2D.new()
	temp_shape.shape = shape.shape
	temp_shape.transform = shape.global_transform
	temp_shape.collide_with_areas = true
	if collision_mask != 0:
		temp_shape.collision_mask = collision_mask
	if motion != Vector2.ZERO:
		temp_shape.motion = motion
	var collisions = world.get_world_2d().direct_space_state.intersect_shape(temp_shape);
	if collisions == null:
		return([])
	
	var nodes = []
	for collision in collisions:
		var node = collision['collider']
		nodes.append(node)
	return nodes
