extends Node2D

# Chemin du script pour les fonctions de sauvegarde
const saving_script = preload("res://script/save.gd")

export var duree_day = 1
export var color_day = Color("#ffffff")
export var color_night = Color("#9a7bc4")

signal night
signal day

var tick = 0
var length_day = 0
var hours = 0
var nb_day = 0

enum {JOUR, NUIT}
var cycle = JOUR

# Quand on entre dans le jeu (à modifier quand le joueur pourra choisir "nouvelle partie" ou "charger partie"
func _on_Game_tree_entered():
	# On load les données sauvegardées
	var data = saving_script.load_data()
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
	saving_script.save_on_quit(world_data, get_node("Player").get_property())

func _ready():
	length_day = 60 * 60 * duree_day
	$Player/Light2D.hide()

func _physics_process(delta):
	tick += 1
	day_cycle()

func day_cycle():
	hours = int(tick / (length_day / 24))
	
	if tick > length_day:
		tick = 0
		nb_day += 1
	
	if hours < 7 or hours > 18:
		cycle_test(NUIT)
	else:
		cycle_test(JOUR)
		
	print(str(tick) + "     -     " + str(hours) + " - " + str(cycle))

func cycle_test(new_cycle):
	if cycle != new_cycle:
		cycle = new_cycle
		var twe = Tween.new()
		
		if cycle == NUIT:
			add_child(twe)
			twe.interpolate_property($CanvasModulate, "color", color_day, color_night, 5, Tween.TRANS_SINE, Tween.EASE_IN)
			twe.start()
			yield(twe, 'tween_completed')
			remove_child(twe)
			$Player/Light2D.show()
			emit_signal("night")
			
		else:
			add_child(twe)
			twe.interpolate_property($CanvasModulate, "color", color_night, color_day, 5, Tween.TRANS_SINE, Tween.EASE_IN)
			twe.start()
			yield(twe, 'tween_completed')
			remove_child(twe)
			$Player/Light2D.hide()
			emit_signal("day")
