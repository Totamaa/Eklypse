extends KinematicBody2D

export (int) var speed = 200

var velocity = Vector2()

var mouse_position = Vector2()

func _physics_process(_delta):
	get_input()
	velocity = move_and_slide(velocity)
	$bras.look_at(mouse_position)

func get_input():
	mouse_position = get_global_mouse_position()
	var ligne_shoot = mouse_position - $bras/Position2D.global_position
	var rota = ligne_shoot.angle()
	
	
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
	velocity = velocity.normalized() * speed

func _on_hitbox_body_entered(body):
	if body.is_in_group("pnj"):
		print("Texte")
		$GUI/Panel.show()


func _on_GUI_yes():
	$GUI/Panel.hide()
