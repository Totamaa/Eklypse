extends Node2D

signal night
signal day

enum {JOUR, NUIT}

const SAVING_SCRIPT = preload("res://script/save.gd")

export var duree_day = 1 # en minutes
export var color_day = Color("#ffffff")
export var color_night = Color("#9a7bc4")

var tick = 0 # 'moment' de la journée
var length_day = 0
var hours = 0
var nb_day = 0
var cycle = JOUR


# Fonction qui commence quand l'objet apparait pour la 1ère fois
func _ready():
	length_day = 60 * 60 * duree_day # 60 ticks par seconde et 60 secondes par minute
	tick = length_day / 2 # la moitié du jour: débute a midi
	$Player/Light2D.hide()


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
			add_child(twe)
			twe.interpolate_property($CanvasModulate, "color", color_day, color_night, 5, Tween.TRANS_SINE, Tween.EASE_IN)
			twe.start()
			yield(twe, 'tween_completed')
			remove_child(twe)

			$Player/Light2D.show()

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

# Sauvegarde (fonction au lencement du jeu)
func _on_Game_tree_entered():
	var data = SAVING_SCRIPT.load_data()
	get_node("Player").set("position", str2var("Vector2" + data["player"]["position"]))

# Fonction pour appeler la sauvegarde quand le jeu se ferme
func _on_Game_tree_exited():
	SAVING_SCRIPT.save_on_quit(get_node("Player").get_property())
			
