extends KinematicBody2D

export var mobMaxHealth = 100
export var detectionDay = 400
export var detectionNight = 800
export var speedDay = 125
export var speedNight = 200
export var attackDay = 8
export var attackNight = 12
export var timeToBeHealth = 5
export var xpKill = 20


var Joueur # Le noeud du joueur
var Nav # Le noeud de la navigation
var detection = detectionDay
var speed = speedDay
var attack = attackDay
var distance
var vel = Vector2()
var timeBeforeHealt = timeToBeHealth * 60
var random = RandomNumberGenerator.new()


onready var _droped_item = preload("res://scene/Item.tscn")
onready var last_healt = $ProgressBar.value

signal die

# Fonction qui commence quand l'objet apparait pour la 1ère fois
func _ready():

	add_to_group("enemy")
	
	# animation du monstre
	$AnimationPlayer.play("idle")

	# attribution des noeuds
	Joueur = get_parent().get_node("Player")
	Nav = get_parent().get_node("Navigation2D")

	# initialisation de la vie du monstre
	$ProgressBar.max_value = mobMaxHealth
	$ProgressBar.value = mobMaxHealth
	
	$Line2D.hide()


# Fonctions appelée chaque frame (plusieurs fois par secondes)
func _physics_process(delta):

	$Line2D.global_position = Vector2.ZERO

	# récupération des points pour la nav
	var path:PoolVector2Array = Nav.get_simple_path(self.global_position, Joueur.global_position, true)

	$Line2D.points = path

	# calcule la distance entre le joueur et le mob et se déplace
	if path.size() > 1:
		distance = calcul_distance(path)
		vel = path[1] - self.position
		if distance < detection:
			vel = vel.normalized()
			animation(vel)
			move_and_slide(vel * speed)
	#affiche la barre de vie des monstres si elle est <100
	$ProgressBar.hide() if $ProgressBar.value == 100 else $ProgressBar.show()
	
	# vie du mob
	if $ProgressBar.value == last_healt and $ProgressBar.value < $ProgressBar.max_value:
		timeBeforeHealt -= 1
		if timeBeforeHealt <= 0:
			$ProgressBar.value += 0.5
	last_healt = $ProgressBar.value
	

# fonction qui calcule la distance entre tous les points d'un tableau
func calcul_distance(chemin:PoolVector2Array):
	"""
	:entrée chemin:PoolVector2Array # un tableau de points pour la nav
	:sortie somme:float # la distance pour parcourir tous les points
	:précondition
	:	len(chemin) > 0
	"""
	var somme = 0
	var coX = chemin[0].x
	var coY = chemin[0].y
	for line in chemin:
		var add = sqrt(pow(line.x - coX, 2) + pow(line.y - coY, 2))
		somme += add
		coX = line.x
		coY = line.y
	return somme


# Fonction appelée quand c'est le jour
func _on_scene01_day():
	#changement des stats du mob pour le jour
	detection = detectionDay
	speed = speedDay
	attack = attackDay


func _on_scene01_night():
	#changement des stats du mob pour la nuit
	detection = detectionNight
	speed = speedNight
	attack = attackNight


func animation(vel):
	if vel.x >= 0:
		$Sprite.flip_h = true
	else:
		$Sprite.flip_h = false

	
#fonction des degats du mob
func hit(damage : int):
	$ProgressBar.value -= damage 
	timeBeforeHealt = timeToBeHealth * 60
	if $ProgressBar.value <= 0:
		random.randomize()
		if random.randi_range(1,1) == 1:
			var droped_item = _droped_item.instance()
			droped_item.set_item_data(load("res://Resources/ItemData/HP_Potion.tres"))
			get_parent().add_child(droped_item)
			droped_item.add_to_group("collectables")
			droped_item.global_position = get_parent().get_node("enemi").global_position
			get_parent().get_node("Inventory").get_collectables()
		emit_signal("die")
		queue_free()
		


func _on_VisibilityNotifier2D_viewport_exited(viewport):
	$VisibilityNotifier2D/Timer.start()


func _on_Timer_timeout():
	queue_free()


func _on_VisibilityNotifier2D_viewport_entered(viewport):
	$VisibilityNotifier2D/Timer.stop()
