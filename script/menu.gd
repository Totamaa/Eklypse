extends Control

func _ready():
	$VBoxContainer/bContinuer.grab_focus() #c'est celui qui sera sélectionné par défaut
	var file = File.new()
	
	if file.file_exists("save.json"):
		$VBoxContainer/bContinuer.disabled = false
	else:
		$VBoxContainer/bContinuer.disabled = true
	

func _on_bContinuer_pressed():
	get_tree().change_scene("res://scene/Game.tscn") #à changer : mettre le lien de la "vraie" scène

func _on_bNouvellePartie_pressed():
	get_tree().change_scene("res://scene/Game.tscn") #à changer : mettre le lien de la "vraie" scène

func _on_bOptions_pressed():
	get_tree().change_scene("res://scene/options.tscn")

func _on_bQuitter_pressed():
	get_tree().quit()
