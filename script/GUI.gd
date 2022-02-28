extends CanvasLayer

signal yes

func _ready():
	$Panel.hide()



func _on_Button_pressed():
	emit_signal("yes")
