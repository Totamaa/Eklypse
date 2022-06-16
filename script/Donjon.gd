extends Node2D


var xpKill = 100
const SAVING_SCRIPT = preload("res://script/save.gd")


func _ready():
	add_child(Global.player)
	$Player/Camera2D.current = false

func _on_Donjon_tree_entered():
	# On load les données sauvegardées
	var data = SAVING_SCRIPT.load_data()
	# On récupère le node "Player"
	var player = get_node("Player")
	# On parcours les données sauvegardées
	for keys in data:
		# Si les données appartiennent au joueur
		if keys == "player":
			# Alors on récupère les données liées au joueur
			for p_keys in data[keys]:
				if p_keys == "level":
					player.set_level(data[keys][p_keys])
	player.set("position", Vector2(-100, 250))
	get_node("Player").update_carac()
	get_node("Player").update_display()

#fonction des degats du mob
func hit(attacker: Player, damage : int):
	$ProgressBar.value -= damage
	
	# si l'ennemi n'a plus de vie
	if $ProgressBar.value <= 0:
		attacker.add_xp(xpKill)
		queue_free()
