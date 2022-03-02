extends KinematicBody2D

var target
var nav
var vel = Vector2()
export var detectionDay = 400
export var detectionNight = 800
var detection = detectionDay
export var speedDay = 125
export var speedNight = 200
var speed = speedDay
var distance

func _ready():
	$AnimationPlayer.play("idle")
	target = get_parent().get_node("Player")
	nav = get_parent().get_node("Navigation2D")
	#Line2D.hide()

func _physics_process(delta):
	$Line2D.global_position = Vector2.ZERO
#	vel = target.global_position - self.global_position
#	vel = vel.normalized()
	var path:PoolVector2Array = nav.get_simple_path(self.global_position, target.global_position, true)
	$Line2D.points = path
	if path.size() > 1:
		distance = calcul_distance(path)
		vel = path[1] - self.position
		if distance < detection:
			move_and_slide(vel.normalized() * speed)
	else:
		print("nok")
		

func calcul_distance(chemin:PoolVector2Array):
	var somme = 0
	var coX = chemin[0].x
	var coY = chemin[0].y
	for line in chemin:
		var add = sqrt(pow(line.x - coX, 2) + pow(line.y - coY, 2))
		somme += add
		coX = line.x
		coY = line.y
	return somme


func _on_scene01_day():
	detection = detectionDay
	speed = speedDay


func _on_scene01_night():
	detection = detectionNight
	speed = speedNight
