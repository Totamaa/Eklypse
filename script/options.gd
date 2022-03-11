extends Control

func _ready():
	$VBoxContainer/bRetour.grab_focus()

func _on_bRetour_pressed():
	get_tree().change_scene("res://scene/menu.tscn")
