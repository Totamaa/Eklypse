extends KinematicBody2D

export var hpMax = 4000
export var hp = 4000
export var speed = 50
export var attack = 1

var phase = 1
var bullet = preload("res://scene/bullet.tscn")

var directionX = 0
var directionY = 0

func _ready():
	add_to_group("enemy")
	$CanvasLayer/BossHP.max_value = hp
	update_display()
	$AnimatedSprite.play("Left")

func _physics_process(delta):
	
	var velocity = Vector2(directionX, directionY).normalized() * speed
	move_and_slide(velocity)


func update_display():
	$CanvasLayer/BossHP.value = hp 
	

#fonction des degats du mob
func hit(attacker: Player, damage : int):
	hp -= damage
	update_display()
	if hp <= 0:
		$AnimatedSprite.play("Death")
		
		$Timer.stop()
		$Timer.wait_time = 2
		$Timer.start()


func _on_BossHP_value_changed(value):
	# Le boss passe en phase 3
	if value < hpMax / 3 and phase == 2:
		$Timer.stop()
		speed += 100
		attack += attack / 2
		phase += 1
		$AnimatedSprite.play("nextPhase")
		$Timer.wait_time = 3.6
		$Timer.start()
	
	# Le boss passe en phase 2
	elif value < (2 * hpMax) / 3 and phase == 1:
		$Timer.stop()
		speed += 100
		attack += attack
		phase += 1
		$AnimatedSprite.play("nextPhase")
		$Timer.wait_time = 2.4
		$Timer.start()

func _on_Timer_timeout():
	var rng = RandomNumberGenerator.new()
	rng.randomize()
	var action = rng.randi_range(1, 3)
	
	if phase == 2 and $Timer.wait_time != 1.25:
		$Timer.wait_time = 1.25
	if phase == 3 and $Timer.wait_time != 0.5:
		$Timer.wait_time = 0.5
	
	if hp <= 0:
		queue_free()
	else:
		# déplacement
		if action == 1:
			directionX = rng.randf_range(-1, 1)
			directionY = rng.randf_range(-1, 1)
			var vel = Vector2(directionX, directionY).normalized() * speed * 50
			if directionX <= 0:
				$AnimatedSprite.play("Left")
			else:
				$AnimatedSprite.play("Right")
			
		# sprint
		elif action == 4:
			if $AnimatedSprite.get_animation() == "nextPhase":
				$AnimatedSprite.play("Left")

		# ne fait rien
		elif action == 3:
			if $AnimatedSprite.get_animation() == "nextPhase":
				$AnimatedSprite.play("Left")
		
		# lance les piques
		elif action == 2:
			if $AnimatedSprite.get_animation() == "nextPhase":
				$AnimatedSprite.play("Left")
				
			var bt = bullet.instance()
			var btr = bullet.instance()
			var br = bullet.instance()
			var bbr = bullet.instance()
			var bb = bullet.instance()
			var bbl = bullet.instance()
			var bl = bullet.instance()
			var btl = bullet.instance()
			
			bt.start($shoot/top.global_position, Vector2(0, -1))
			get_parent().add_child(bt)
			btr.start($shoot/topRight.global_position, Vector2(1, -1))
			get_parent().add_child(btr)
			br.start($shoot/right.global_position, Vector2(1, 0))
			get_parent().add_child(br)
			bbr.start($shoot/botRight.global_position, Vector2(1, 1))
			get_parent().add_child(bbr)
			bb.start($shoot/bot.global_position, Vector2(0, 1))
			get_parent().add_child(bb)
			bbl.start($shoot/botLeft.global_position, Vector2(-1, 1))
			get_parent().add_child(bbl)
			bl.start($shoot/left.global_position, Vector2(-1, 0))
			get_parent().add_child(bl)
			btl.start($shoot/topLeft.global_position, Vector2(-1, -1))
			get_parent().add_child(btl)












