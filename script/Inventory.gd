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


func _physics_process(delta):
	$Stats/VBoxContainer/Level.set_text("Level : " + str(get_parent().get_node("Player").niveau))
	$Stats/VBoxContainer/HP.set_text("HP : " + str(get_node("../Player/GUI/VBoxContainer/HBox_HP/life").value) + " / " + str(get_node("../Player/GUI/VBoxContainer/HBox_HP/life").max_value))
	$Stats/VBoxContainer/Force.set_text("Force : " + str(get_parent().get_node("Player").degats))
	$Stats/VBoxContainer/Vitesse.set_text("Speed : " + str(get_parent().get_node("Player").speed))
