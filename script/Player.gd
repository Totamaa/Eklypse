extends KinematicBody2D

export var speed = 200
export var timeToBeHealth = 3 # temps avant que le joueur se heal en secondes

var velocity = Vector2()
var mouse_position = Vector2()
var timeBeforeHealt = timeToBeHealth * 60

onready var last_healt = $GUI/life.value

# Fonctions appelée chaque frame (plusieurs fois par secondes)
func _physics_process(_delta):
	# gère les entrées claviées
	get_input()

	# déplacement du joueur
	velocity = move_and_slide(velocity)

	$bras.look_at(mouse_position)
	
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
	var ligne_shoot = mouse_position - $bras/Position2D.global_position
	var rota = ligne_shoot.angle()
	
	# déplacement + animation
	velocity = Vector2()
	if Input.is_action_pressed("ui_right"):
		velocity.x += 1
		$Sprite.flip_h = false
		$bras.flip_v = false
		$bras.position.x = -5
		$animPlayer.play("walk")
	if Input.is_action_pressed("ui_left"):
		velocity.x -= 1
		$Sprite.flip_h = true
		$bras.flip_v = true
		$bras.position.x = 5
		$animPlayer.play("walk")
	if Input.is_action_pressed("ui_down"):
		velocity.y += 1
		$animPlayer.play("walk")
	if Input.is_action_pressed("ui_up"):
		velocity.y -= 1
		$animPlayer.play("walk")
	if velocity == Vector2(0, 0):
		$animPlayer.play("idle")
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
		$GUI/life.value -= get_parent().get_node("enemi").attack
		timeBeforeHealt = timeToBeHealth * 60


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
