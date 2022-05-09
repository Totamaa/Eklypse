extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var is_visible = false

# Called when the node enters the scene tree for the first time.
func _ready():
	self.visible = is_visible
	$ColorRect.visible = false
	
func _process(delta):
	self.set_global_position(get_parent().get_node("Player").global_position)
	
func display_inventory():
	$ColorRect.visible = false
	is_visible = not is_visible
	self.visible = is_visible


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
