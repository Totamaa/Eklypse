extends Control


func _ready():
	var twe = Tween.new()
	add_child(twe)
	twe.interpolate_property($CanvasModulate, "color", Color(255, 0, 0, 1), Color(255, 0, 0, 0), 5, Tween.TRANS_SINE, Tween.EASE_IN)
	twe.start()
	yield(twe, 'tween_completed')
	remove_child(twe)
	

func _on_Timer_timeout():
	get_tree().change_scene("res://scene/menu.tscn")
