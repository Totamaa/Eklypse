extends KinematicBody2D

export var mobMaxHealth = 100
export var detectionDay = 400
export var detectionNight = 800
export var speedDay = 125
export var speedNight = 200
export var attackDay = 8
export var attackNight = 12

var Joueur # Le noeud du joueur
var Nav # Le noeud de la navigation
var detection = detectionDay
var speed = speedDay
var attack = attackDay
var distance
var vel = Vector2()


# Fonction qui commence quand l'objet apparait pour la 1ère fois
func _ready():

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
			move_and_slide(vel.normalized() * speed)
	
	#affiche la barre de vie des monstres si elle est <100
	$ProgressBar.hide() if $ProgressBar.value == 100 else $ProgressBar.show()
	

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
