extends Node2D
class_name Item

export var item_data : Resource = null setget set_item_data, get_item_data
signal playerEntered

func set_item_data(value: Resource) -> void:
	item_data = value
	if item_data != null:
		$Sprite.set_texture(item_data.world_texture)
		
func get_item_data() -> Resource:
	return item_data


func _on_Area2D_area_entered(area):
	emit_signal("playerEntered", item_data)
	queue_free()
