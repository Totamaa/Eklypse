extends Control

const SAVE_MANAGER = preload("res://script/save.gd")

var file = File.new()
var dir = Directory.new()

func _ready():
	$VBoxContainer/bContinuer.grab_focus() #c'est celui qui sera sélectionné par défaut
	
	if _get_dir_len() > 0:
		$VBoxContainer/bContinuer.disabled = false
	else:
		$VBoxContainer/bContinuer.disabled = true
		
	for i in range(_get_dir_len()):
		$saves.get_child(i).get_child(0).text = _get_save_name()[i]
		
	for save in $saves.get_children():
		if save.get_child(0).text == "Vide":
			save.get_child(1).disabled = true
	
func _get_dir_len():
	var dlen = 0
	if dir.open("res://saves") == OK:
		dir.list_dir_begin()
		while dir.get_next() != "":
			if not dir.current_is_dir():
				dlen += 1
	return dlen
	
func _get_save_name():
	var saves = []
	if dir.open("res://saves") == OK:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name != "":
			if not dir.current_is_dir():
				saves.append(file_name)
			file_name = dir.get_next()
	return saves
	
func _on_bContinuer_pressed():
	$saves.visible = true
	$bRetour.visible = true
	$VBoxContainer.visible = false

func _on_bNouvellePartie_pressed():
	$new_game.visible = true
	$bRetour.visible = true
	$VBoxContainer.visible = false
#	get_tree().change_scene("res://scene/Game.tscn") #à changer : mettre le lien de la "vraie" scène

func _on_bOptions_pressed():
	print_debug(dir.list_dir_begin())

func _on_bQuitter_pressed():
	get_tree().quit()


func _on_bSave1_pressed():
	Global.set_save_path($saves/Save1/Label.text)
	get_tree().change_scene("res://scene/Game.tscn") #à changer : mettre le lien de la "vraie" scène

func _on_bSave2_pressed():
	Global.set_save_path($saves/Save2/Label.text)
	get_tree().change_scene("res://scene/Game.tscn") #à changer : mettre le lien de la "vraie" scène

func _on_bSave3_pressed():
	Global.set_save_path($saves/Save3/Label.text)
	get_tree().change_scene("res://scene/Game.tscn") #à changer : mettre le lien de la "vraie" scène


func _on_bJouer_pressed():
	SAVE_MANAGER.create_save_file($new_game/LineEdit.text)
	get_tree().change_scene("res://scene/Game.tscn")

func _on_bRetour_pressed():
	$saves.visible = false
	$bRetour.visible = false
	$new_game.visible = false
	$VBoxContainer.visible = true
