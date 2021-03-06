extends ItemList


var ItemListContent = {}


# Called when the node enters the scene tree for the first time.
func _ready():
	_push_Items()
	
func get_item_content():
	return ItemListContent
	
func get_item_content_list_keys():
	var tabl = []
	for key in ItemListContent:
		tabl.append(key)
	return tabl
	
func get_item_content_list_values():
	var tabl = []
	for value in ItemListContent.values():
		tabl.append(value)
	return tabl

func _push_Items():
	self.clear()
	for key in ItemListContent:
		var label = "(x" + str(ItemListContent[key]) + ") " + key.item_name
		var description = "\nDescription"
		self.add_item(label, key.inventory_texture, true)	

func use_item(item,index):
	if ItemListContent[item] > 1:
		ItemListContent[item] = ItemListContent[item] - 1
	else:
		ItemListContent[item] = ItemListContent[item] - 1
		self.remove_item(index)
		
	
func item_collected(Item_data: ItemData):
	if Item_data in ItemListContent:
		ItemListContent[Item_data] += 1
	else:
		ItemListContent[Item_data] = 1
	_push_Items()


func _on_ItemList_item_selected(index):
	if not get_parent().get_parent().get_node("ColorRect").visible:
		get_parent().get_parent().get_node("ColorRect").visible = true
	var item_name = ItemListContent.keys()[index].item_name
	var item_texture = ItemListContent.keys()[index].inventory_texture
	var item_description = ItemListContent.keys()[index].description
	get_parent().get_parent().get_node("ColorRect/item_name").text = item_name
	get_parent().get_parent().get_node("ColorRect/TextureRect").texture = item_texture
	get_parent().get_parent().get_node("ColorRect/item_description").text = item_description
	
