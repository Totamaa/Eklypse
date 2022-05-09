extends CanvasLayer

signal yes
signal level_up


# Fonction qui commence quand l'objet apparait pour la 1ère fois
func _ready():
	$Panel.hide()
#	$VBoxContainer/HBox_HP/life.size.x = 100
	

func _on_Button_pressed():
	emit_signal("yes")



func _on_xp_value_changed(value):
	if $VBoxContainer/HBox_XP/xp.value == $VBoxContainer/HBox_XP/xp.max_value:
		emit_signal("level_up")
