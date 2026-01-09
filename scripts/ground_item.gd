extends RigidBody2D

@export var pickup_visual: Node2D


var display_pick_up_possible = false




func _process(_delta: float) -> void:
	pickup_visual.visible = display_pick_up_possible

func add_item(node):
	node.reparent(get_node('item_container'))
	node.position = Vector2.ZERO

func pick_up(_player):
	self.queue_free()
