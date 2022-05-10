extends Control
class_name Inventory

var item_list : Array = []
var hidden = true
var empty_style = StyleBoxFlat.new()
var empty_style_color = "#664949"

class ItemAmout:
	var amount : int = 0
	var item = null
	
	func _init(_amount: int, _item) -> void:
		amount = _amount
		item = _item

func _ready():
	self.hide()
	empty_style.bg_color = empty_style_color
	for elt in $GridContainer.get_children():
		elt.set("custom_styles/panel", empty_style)
		
func get_collectables():
	for col in get_tree().get_nodes_in_group("collectables"):
		col.connect("playerEntered", self, "_append_item")
		
func _process(delta):
	var x = get_parent().get_node("Player").position.x - $GridContainer.get_rect().size.x / 2
	var y = get_parent().get_node("Player").position.y + 150
	self.set_global_position(Vector2(x,y))

func _append_item(item, amount: int = 1) -> void:
	var item_amout_id = _check_if_item_present(item)
	if item_amout_id != -1:
		item_list[item_amout_id].amount += 1
	else:
		item_list.append(ItemAmout.new(amount, item))
		
func _remove_item(item, amount: int = 1) -> void:
	var item_amount_id = item_list.find(item)
	if item_amount_id != -1:
		item_list[item_amount_id].amount -= 1
		if item_list[item_amount_id] <= 0:
			item_list.remove(item_amount_id)
	else:
		push_error("%s ne peut pas être supprimé !" % item)
		
func _check_if_item_present(item) -> int:
	for i in range(len(item_list)):
		if item_list[i].item.item_name == item.item_name:
			return i
	
	return -1

func print_inventory() -> void:
	if hidden:
		for i in range(len(item_list)):
			var sbt = StyleBoxTexture.new()
			sbt.texture = item_list[i].item.inventory_texture
			$GridContainer.get_children()[i].set("custom_styles/panel", sbt)
			$GridContainer.get_children()[i].get_node("Label").text = str(item_list[i].amount)
			print("ok")
		self.show()
		hidden = false
	else:
		self.hide()
		hidden = true
	print("--- INVENTORY ---")
	print(" ")
	for item_amount in item_list:
		print(item_amount.amount, "x ", item_amount.item.item_name)
	print(" ")

	
