extends KinematicBody2D

class_name Player


export var timeToBeHealth = 5 # temps avant que le joueur se heal en secondes
export var niveau = 1

var counter = 0			# Compteur pour la vitesse de récupération de la vie
var recoveringSpeed = 1	# Temps entre chaque hpRecovered
var hpRecovered = 1		# Nombre de HP récupéré en recoveringSpeed seconde(s)
var velocity = Vector2()
var mouse_position = Vector2()
var timeBeforeHealt = timeToBeHealth * 60

onready var last_healt = $GUI/VBoxContainer/HBox_HP/life.value
onready var weapon = $Weapon
onready var speed = 300 + (niveau - 1)
onready var degats = 20 + (niveau - 1)

func _ready():
	add_to_group("player")
	$GUI/VBoxContainer/HBox_HP/life.max_value = 100 + 20 * (niveau - 1)
	$GUI/VBoxContainer/HBox_HP/life.value = $GUI/VBoxContainer/HBox_HP/life.max_value

# Fonctions appelée chaque frame (plusieurs fois par secondes)
func _physics_process(_delta):
	# gère les entrées claviées
	get_input()
	counter += _delta

	# déplacement du joueur
	velocity = move_and_slide(velocity)

	$Weapon.look_at(mouse_position)
	
	# vie du perso
	if $GUI/VBoxContainer/HBox_HP/life.value == last_healt and $GUI/VBoxContainer/HBox_HP/life.value < $GUI/VBoxContainer/HBox_HP/life.max_value:
		timeBeforeHealt -= 1
		if timeBeforeHealt <= 0 and counter >= recoveringSpeed:
			$GUI/VBoxContainer/HBox_HP/life.value += hpRecovered
			counter = 0
	last_healt = $GUI/VBoxContainer/HBox_HP/life.value


# fonction qui gère les entrées claviées
func get_input():
	# bras qui suit la souris
	mouse_position = get_global_mouse_position()
	var ligne_shoot = mouse_position - $Weapon/Position2D.global_position
	var _rota = ligne_shoot.angle()
	
	# déplacement + animation
	velocity = Vector2()
	if Input.is_action_pressed("ui_right"):
		velocity.x += 1
		$Sprite.flip_h = false
	if Input.is_action_pressed("ui_left"):
		velocity.x -= 1
		$Sprite.flip_h = true
	if Input.is_action_pressed("ui_down"):
		velocity.y += 1
	if Input.is_action_pressed("ui_up"):
		velocity.y -= 1
	playAnimation(velocity)
	velocity = velocity.normalized() * speed # normaliezd = vectreur de longueur 1
	

# collision
func _on_hitbox_body_entered(body):
	"""
	:entrée body: corp avec lequel l'objet colisionne
	"""
		
	# collision avec un mob
	if body.is_in_group("enemy"):
		if get_parent().get_node("enemi") != null:
			if $GUI/VBoxContainer/HBox_HP/life.value - get_parent().get_node("enemi").attack < 0:
				$GUI/VBoxContainer/HBox_HP/life.value = 0
				get_tree().change_scene("res://scene/Die.tscn")
			else:
				$GUI/VBoxContainer/HBox_HP/life.value -= get_parent().get_node("enemi").attack
			
		timeBeforeHealt = timeToBeHealth * 60
		# bump 
#		var point_col = global_position - body.global_position
#		velocity.x = sign(point_col.x) * 5 * speed
#		velocity.y = sign(point_col.y) * 5 * speed
#		velocity = move_and_slide(velocity)
		

#fonction pour l'attque

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("f_attack"):
		weapon.attack()
		annimAttack()
		
	

# fonction mal faites du dialogue
func _on_GUI_yes():
	$GUI/Panel.hide()
	

# fonction pour la sauvegarde
func get_property():
	"""
	:sortie dict_propery: dictionnaire # pour la save en json
	"""
	var dict_propery = {
		"position": self.global_position
	}
	
	return dict_propery

func playAnimation(v):
	if v.x == 1:
		$animPlayer.play("walk_side")
	elif v.x == -1:
		$animPlayer.play("walk_side")
	elif v.y == 1:
		$animPlayer.play("walk_down")
	elif v.y == -1:
		$animPlayer.play("walk_up")


func _on_GUI_level_up():
	"""
	: Augmente les stats du joueurs quand il level up
	"""
	niveau += 1
	$GUI/VBoxContainer/HBox_XP/xp.value = 0
	$GUI/VBoxContainer/HBox_XP/xp.max_value = 100 + 50 * (niveau - 1)
	speed = 300 + (niveau - 1)
	degats = 20 + (niveau - 1)
	$GUI/VBoxContainer/HBox_HP/life.max_value = 100 + 20 * (niveau - 1)
	$GUI/VBoxContainer/HBox_HP/life.value = $GUI/VBoxContainer/HBox_HP/life.max_value
	$GUI/VBoxContainer/niveau.set_text("Level: " + str(niveau))


func add_xp(xpKill):
	"""
	: ajout de l'xp au joueur quand il tue un ennemi
	"""
	$GUI/VBoxContainer/HBox_XP/xp.value += xpKill
	

func annimAttack():
	"""
	: animation de l'attaque du joueur
	"""
	mouse_position = get_global_mouse_position()
	var souris_placement = mouse_position - self.global_position
	# dans quelle carré
	if souris_placement.x > 0 and souris_placement.y > 0:
		print_debug("en bas a droite")
		if souris_placement.x > souris_placement.y:
			pass
			$animPlayer.play("attack_right")
		else:
			$animPlayer.play("attack_down")
	elif souris_placement.x > 0 and souris_placement.y <= 0:
		print_debug("en haut a droite")
		if souris_placement.x > -souris_placement.y:
			$animPlayer.play("attack_right")
		else:
			$animPlayer.play("attack_up")
	elif souris_placement.x <= 0 and souris_placement.y > 0:
		print_debug("en bas a gauche")
		if -souris_placement.x > souris_placement.y:
			$animPlayer.play("attack_left")
		else:
			$animPlayer.play("attack_down")
	elif souris_placement.x<= 0 and souris_placement.y <= 0:
		print_debug("en haut a gauche")
		if -souris_placement.x > -souris_placement.y:
			$animPlayer.play("attack_left")
		else:
			$animPlayer.play("attack_up")
	
	
	
