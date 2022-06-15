extends KinematicBody2D

var speed = 1000
var vel = Vector2()
var player:Player

func _physics_process(delta):
	var collision = move_and_collide(vel * delta)
	if collision:
		if collision.collider.is_in_group("player"):
			player = collision.collider
			player.takeDamage(get_parent().get_node("Boss").attack)
		queue_free()

func start(pos, dir:Vector2):
	position = pos
	vel = Vector2(dir.x, dir.y) * speed
	if dir.x == 1 and dir.y == -1:
		$Sprite.rotate(- PI / 4)
	if dir.x == 1 and dir.y == 0:
		$Sprite.rotate(- PI / 2)
	if dir.x == 1 and dir.y == 1:
		$Sprite.rotate(- 3 * PI / 4)
	if dir.x == 0 and dir.y == -1:
		$Sprite.rotate(0)
	if dir.x == 0 and dir.y == 1:
		$Sprite.rotate(PI)
	if dir.x == -1 and dir.y == -1:
		$Sprite.rotate(PI / 4)
	if dir.x == -1 and dir.y == 0:
		$Sprite.rotate(PI / 2)
	if dir.x == -1 and dir.y == 1:
		$Sprite.rotate(3 * PI / 4)
	



