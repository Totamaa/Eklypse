extends KinematicBody2D

export var speed = 200
export var timeToBeHealth = 3 # temps avant que le joueur se heal en secondes


var velocity = Vector2()
var mouse_position = Vector2()
var timeBeforeHealt = timeToBeHealth * 60

onready var last_healt = $GUI/life.value
onready var weapon = $Weapon

func _ready():
	add_to_group("player")

# Fonctions appelée chaque frame (plusieurs fois par secondes)
func _physics_process(_delta):
	# gère les entrées claviées
	get_input()

	# déplacement du joueur
	velocity = move_and_slide(velocity)

	$Weapon.look_at(mouse_position)
	
	# vie du perso
	if $GUI/life.value == last_healt and $GUI/life.value < $GUI/life.max_value:
		timeBeforeHealt -= 1
		if timeBeforeHealt <= 0:
			$GUI/life.value += 0.5
	last_healt = $GUI/life.value


# fonction qui gère les entrées claviées
func get_input():
	# bras qui suit la souris
	mouse_position = get_global_mouse_position()
	var ligne_shoot = mouse_position - $Weapon/Position2D.global_position
	var rota = ligne_shoot.angle()
	
	# déplacement + animation
	velocity = Vector2()
	if Input.is_action_pressed("ui_right"):
		velocity.x += 1
		$Sprite.flip_h = false
		$animPlayer.play("walk_side")
	if Input.is_action_pressed("ui_left"):
		velocity.x -= 1
		$Sprite.flip_h = true
		$animPlayer.play("walk_side")
	if Input.is_action_pressed("ui_down"):
		velocity.y += 1
		$animPlayer.play("walk_down")
	if Input.is_action_pressed("ui_up"):
		velocity.y -= 1
		$animPlayer.play("walk_up")
#	if velocity == Vector2(0, 0):
#		$animPlayer.play("idle")
	velocity = velocity.normalized() * speed # normaliezd = vectreur de longueur 1
	

# collision
func _on_hitbox_body_entered(body):
	"""
	:entrée body: corp avec lequel l'objet colisionne
	"""
	# collision avec un pnj
	if body.is_in_group("pnj"):
		$GUI/Panel.show()
		
	# collision avec un mob
	if body.is_in_group("enemy"):
		print("BAAAAAAAAAAM")
		if $GUI/life.value - get_parent().get_node("enemi").attack < 0:
			$GUI/life.value = 0
		else:
			$GUI/life.value -= get_parent().get_node("enemi").attack
			
		timeBeforeHealt = timeToBeHealth * 60

#fonction pour l'attque

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("f_attack"):
		weapon.attack()
		$animPlayer.play("attack_down")
		
	

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
