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
	if self.visible == false:
		get_node("ColorRect").visible = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func get_inventory():
	var inv = {"consommables": null, "equipements": null}
	inv["consommables"] = $TabContainer/Consommables.get_item_content()
	inv["equipements"] = $TabContainer/Equipements.get_item_content()
	return inv


func _on_TabContainer_tab_changed(tab):
	if get_node("ColorRect").visible == true:
		get_node("ColorRect").visible = false
		
func _physics_process(delta):
	$Stats/VBoxContainer/Level.set_text("Level : " + str(get_parent().get_node("Player").niveau))
	$Stats/VBoxContainer/HP.set_text("HP : " + str(get_node("../Player/GUI/VBoxContainer/HBox_HP/life").value) + " / " + str(get_node("../Player/GUI/VBoxContainer/HBox_HP/life").max_value))
	$Stats/VBoxContainer/Force.set_text("Force : " + str(get_parent().get_node("Player").degats))
	$Stats/VBoxContainer/Vitesse.set_text("Speed : " + str(get_parent().get_node("Player").speed))


func _on_Consommables_item_activated(index):
	var current_tab = get_node("TabContainer").get_current_tab_control()
	if current_tab.name == "Consommables":
		pass
