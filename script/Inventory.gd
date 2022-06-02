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
