extends RigidBody2D

@export var pickup_visual: Node2D

@onready var item_container = get_node('item_container')


var display_pick_up_possible = false




func _process(_delta: float) -> void:
	pickup_visual.visible = display_pick_up_possible

func add_item(node):
	node.reparent(get_node('item_container'))
	node.position = Vector2.ZERO

func pick_up(player):
	item_container.get_child(0).pick_up(player)
	self.queue_free()
