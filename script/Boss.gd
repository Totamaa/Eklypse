extends KinematicBody2D

export var hpMax = 4000
export var hp = 4000
export var speed = 500
export var attack = 25

var phase = 1
var bullet = preload("res://scene/bullet.tscn")

func _ready():
	add_to_group("enemy")
	$CanvasLayer/BossHP.max_value = hp
	update_display()
	$AnimatedSprite.play("Left")


func update_display():
	$CanvasLayer/BossHP.value = hp 
	

#fonction des degats du mob
func hit(attacker: Player, damage : int):
	hp -= damage
	update_display()
	if hp <= 0:
		$AnimatedSprite.play("Death")
		queue_free()


func _on_BossHP_value_changed(value):
	# Le boss passe en phase 3
	if value < hpMax / 3 and phase == 2:
		speed += 100
		attack += attack / 2
		phase += 1
	
	# Le boss passe en phase 2
	elif value < (2 * hpMax) / 3 and phase == 1:
		speed += 100
		attack += attack
		phase += 1

func _on_Timer_timeout():
	var rng = RandomNumberGenerator.new()
	rng.randomize()
	var action = rng.randi_range(1, 4)
	
	# déplacement
	if action == 1:
		var directionX = rng.randf_range(-1, 1)
		var directionY = rng.randf_range(-1, 1)
		var vel = Vector2(directionX, directionY).normalized() * speed
		move_and_slide(vel)
		print_debug("Déplacement du boss starf ", vel)
		
	# sprint
	elif action == 2:
		pass

	# ne fait rien
	elif action == 3:
		pass
	
	# lance les piques
	elif action == 4:
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












