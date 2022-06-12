extends KinematicBody2D

class_name Player
"""
Variables concernant les caractéristiques
"""
var level 			= 1							# Niveau du joueur
var experience 		= 0							# Expérience du joueur
var maxHealth 		= 100 + 20 * (level - 1)	# Points de vie maximaux du joueur au level L
var currentHealth 	= maxHealth					# Points de vie actuels du joueur
var strength 		= 1 * level					# Force du joueur
var damage			= 20 + strength				# Dégats infligés par le joueur
var speed 			= 300 + (level - 1)			# Vitesse de déplacement du joueur

"""
Variables concernant la mécanique du joueur
"""
# Expérience requise par niveau [1,2,3...]. XPreq = xp précédent + (xp précédent * 0.25)
var exp_table 		=	[100, 125, 156, 195, 244, 305, 381, 476, 595, 744, 930, 1163, 1454, 1818, 2273, 2841, 3551, 4439, 5549, 6936]
var timeToBeHealth 	= 5 # Nombre de seconde(s) avant la récupération de la vie
var hpRecovered 	= 1	# Nombre de point(s) de vie récupéré(s) par recoveringSpeed seconde(s)
var recoveringSpeed = 1	# Nombre de seconde(s) entre chaque hpRecovered point(s) de vie récupéré(s)

signal lvl_up(level)

signal level5


export var niveau = 1

var counter = 0			# Compteur pour la vitesse de récupération de la vie


var velocity = Vector2()
var mouse_position = Vector2()
var timeBeforeHeal = timeToBeHealth * 60

onready var last_healt = $GUI/VBoxContainer/HBox_HP/life.value
onready var weapon = $Weapon

func _ready():
	add_to_group("player")
	$GUI/VBoxContainer/HBox_HP/life.max_value = 100 + 20 * (niveau - 1)
	$GUI/VBoxContainer/HBox_HP/life.value = $GUI/VBoxContainer/HBox_HP/life.max_value

# Fonctions appelée chaque frame (plusieurs fois par secondes)
func _physics_process(_delta):
	"""
	Pour information : la variable _delta vaut 0.0167 et correspond au temps d'affichage d'une image.
	On a donc 60 fps (1 / 0.0167)
	"""
	# gère les entrées claviées
	get_input()
	# déplacement du joueur
	velocity = move_and_slide(velocity)

	$Weapon.look_at(mouse_position)
	
	# Récupération automatique de la vie
	"""
	Si la vie du joueur est inférieur au maximum de points de vie qu'il peut avoir alors la récupération automatique peut débuter
	"""
	if currentHealth < maxHealth:
		# Si le temps d'attente pour être automatiquement soigné est dépassé, on soigne
		if timeBeforeHeal <= 0:
			counter += _delta	# On incrémente la variable counter avec _delta (donc elle vaudra 1 dans une seconde)
			# Si la variable counter est supérieure ou égale à recoveringSpeed alors on ajoute hpRecovered PDV
			if counter >= recoveringSpeed:
				currentHealth += hpRecovered
				update_display()
				counter = 0
		else:
			timeBeforeHeal -= 1
			

"""
Fonction qui update les caractèristiques
"""
func update_carac():
	maxHealth 		= 100 + 20 * (level - 1)	# Points de vie maximaux du joueur au level L
	currentHealth 	= maxHealth					# Points de vie actuels du joueur
	strength 		= 1 * level					# Force du joueur
	damage			= 20 + strength				# Dégats infligés par le joueur
	speed 			= 300 + (level - 1)			# Vitesse de déplacement du joueur

"""
Fonction qui update l'affichage de la barre de vie
"""
func update_display():
	$GUI/VBoxContainer/HBox_HP/life.value = currentHealth
	$GUI/VBoxContainer/HBox_XP/xp.value = experience
	$GUI/VBoxContainer/HBox_HP/life.max_value = maxHealth
	$GUI/VBoxContainer/HBox_XP/xp.max_value = exp_table[level-1]

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
	

"""
Fonction qui détecte quand un corps entre en contact avec le joueur
"""
func _on_hitbox_body_entered(body):
	"""
	:entrée body: Corps qui entre en contact avec le joueur
	"""
		
	# Si le corps qui entre en contact est un ennemi
	if body.is_in_group("enemy"):
		if body != null:
			if currentHealth - body.attack < 0:
				currentHealth = 0
				get_tree().change_scene("res://scene/Die.tscn")
			else:
				currentHealth -= body.attack
			update_display()
			
		timeBeforeHeal = timeToBeHealth * 60
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

"""
Fonction qui ajoute l'expérience au joueur
"""
func add_xp(xp):
	experience += xp
	if experience > exp_table[level-1]:
		experience = experience - exp_table[level]
		level_up()
	elif experience == exp_table[level-1]:
		experience = 0
		level_up()
	update_display()
	
"""
Fonction de level up
"""
func level_up():
	print("ok level up")
	level += 1
	update_carac()
	update_display()
	emit_signal("lvl_up", level)
	if level == 5:
		emit_signal("level5")
	

func annimAttack():
	"""
	: animation de l'attaque du joueur
	"""
	if $Sprite.flip_h == true:
		$Sprite.flip_h = false
	 
	mouse_position = get_global_mouse_position()
	var souris_placement = mouse_position - self.global_position
	# dans quelle carré
	if souris_placement.x > 0 and souris_placement.y > 0:
#		print_debug("en bas a droite")
		if souris_placement.x > souris_placement.y:
			pass
			$animPlayer.play("attack_right")
		else:
			$animPlayer.play("attack_down")
	elif souris_placement.x > 0 and souris_placement.y <= 0:
#		print_debug("en haut a droite")
		if souris_placement.x > -souris_placement.y:
			$animPlayer.play("attack_right")
		else:
			$animPlayer.play("attack_up")
	elif souris_placement.x <= 0 and souris_placement.y > 0:
#		print_debug("en bas a gauche")
		if -souris_placement.x > souris_placement.y:
			$animPlayer.play("attack_left")
		else:
			$animPlayer.play("attack_down")
	elif souris_placement.x<= 0 and souris_placement.y <= 0:
#		print_debug("en haut a gauche")
		if -souris_placement.x > -souris_placement.y:
			$animPlayer.play("attack_left")
		else:
			$animPlayer.play("attack_up")
	
	
	
	
