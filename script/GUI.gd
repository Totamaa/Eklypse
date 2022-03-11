extends CanvasLayer

signal yes


# Fonction qui commence quand l'objet apparait pour la 1ère fois
func _ready():
	$Panel.hide()


func _on_Button_pressed():
	emit_signal("yes")
