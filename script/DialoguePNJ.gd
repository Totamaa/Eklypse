extends CanvasLayer

signal buttonPressed


func _on_ButtonTuto_pressed():
	emit_signal("buttonPressed")


func _on_ButtonMission_pressed():
	emit_signal("buttonPressed")


func _on_ButtonWait_pressed():
	emit_signal("buttonPressed")


func _on_ButtonBoss_pressed():
	emit_signal("buttonPressed")
