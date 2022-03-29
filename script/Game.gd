extends Node2D

signal night
signal day

enum {JOUR, NUIT}

# Chemin du script pour les fonctions de sauvegarde
const SAVING_SCRIPT = preload("res://script/save.gd")

export var spawn = 6 # Timer des monstres
export var nbEnemyMax = 3
export var duree_day = 1 # en minutes
export var color_day = Color("#ffffff")
export var color_night = Color("#9a7bc4")

var tick = 0 # 'moment' de la journée
var length_day = 0
var hours = 0
var nb_day = 0
var cycle = JOUR


export(PackedScene) var mob_scene

# Fonction qui commence quand l'objet apparait pour la 1ère fois
func _ready():
	length_day = 60 * 60 * duree_day # 60 ticks par seconde et 60 secondes par minute
	#tick = length_day / 2 # la moitié du jour: débute a midi
	$Player/Light2D.hide()
	$MobTimer.wait_time = spawn


# Fonctions appelée chaque frame (plusieurs fois par secondes)
func _physics_process(delta):
	tick += 1 # avance du temps
	day_cycle()


# fonction qui calcule la durée d'un cycle jour/nuit
func day_cycle():
	hours = int(tick / (length_day / 24))
	
	if tick > length_day:
		tick = 0
		nb_day += 1
	
	if hours < 7 or hours > 18:
		cycle_test(NUIT)
	else:
		cycle_test(JOUR)
	
	print(str(tick) + "     -     " + str(hours) + " - " + str(cycle)) # debug


# Fonction pour le changement de cycle
func cycle_test(new_cycle):
	"""
	:entrée new_cycle: le cycle actuelle
	"""
	# test si c'est un nouveau cycle
	if cycle != new_cycle:
		cycle = new_cycle
		var twe = Tween.new() # variable pour faire le fondu jour/nuit
		
		# si c'est la nuit
		if cycle == NUIT:
			# le fondu jour -> nuit
			if hours >= 20:
				$CanvasModulate.color = color_night
			else:
				add_child(twe)
				twe.interpolate_property($CanvasModulate, "color", color_day, color_night, 5, Tween.TRANS_SINE, Tween.EASE_IN)
				twe.start()
				yield(twe, 'tween_completed')
				remove_child(twe)
				

			$Player/Light2D.show()
			
			$MobTimer.wait_time = spawn / 2

			# signal pour les autres objets
			emit_signal("night")
		
		# si c'est le jour
		else:
			# fondu nuit -> jour
			add_child(twe)
			twe.interpolate_property($CanvasModulate, "color", color_night, color_day, 5, Tween.TRANS_SINE, Tween.EASE_IN)
			twe.start()
			yield(twe, 'tween_completed')
			remove_child(twe)

			$Player/Light2D.hide()

			# signal pour les autres objets
			emit_signal("day")
			
			$MobTimer.wait_time = spawn


# Quand on entre dans le jeu (à modifier quand le joueur pourra choisir "nouvelle partie" ou "charger partie"
func _on_Game_tree_entered():
	# On load les données sauvegardées
	var data = SAVING_SCRIPT.load_data()
	# On récupère le node "Player"
	var player = get_node("Player")
	# On parcours les données sauvegardées
	for keys in data:
		# Si les données appartiennent au joueur
		if keys == "player":
			# Alors on récupère les données liées au joueur (ici uniquement la position)
			for p_keys in data[keys]:
				player.set(p_keys, str2var("Vector2" + data[keys][p_keys]))
		# Si les données appartiennent au monde (heurs, jours ...)
		elif keys == "world":
			# Alors on récupère les données liées au monde
			tick = data[keys]["tick"]		# Les ticks pour connaître le moment exact de la journée
			hours = data[keys]["hours"]		# L'heure pour avoir un variable plus commune que les ticks
			nb_day = data[keys]["nb_day"]	# Le nombre de jour(s) passé(s)


# Fonction pour appeler la sauvegarde quand le jeu se ferme
func _on_Game_tree_exited():
	# On récupère les données concernant le monde
	var world_data = {
		"tick": tick,
		"hours": hours, 
		"nb_day": nb_day
		}
	# On appelle la fonction qui permet de sauvegarder les données
	SAVING_SCRIPT.save_on_quit(world_data, get_node("Player").get_property())



func _on_MobTimer_timeout():
		
	# On choisit un endroit random sur le path du mob 
	var mob_spawn_location = $MobPath/MobSpawnhLocation
	mob_spawn_location.offset = randi()

	# On instancie un mob
	var mob = mob_scene.instance()
	add_child(mob)
	
	# On le place a l'endroit random
	mob.position = mob_spawn_location.position
