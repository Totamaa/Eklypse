extends KinematicBody2D


export var mobMaxHealth = 100
export var detectionDay = 400
export var detectionNight = 800
export var speedDay = 125
export var speedNight = 200

var Target
var Nav
var vel = Vector2()
var detection = detectionDay
var speed = speedDay
var distance

func _ready():
	$AnimationPlayer.play("idle")
	Target = get_parent().get_node("Player")
	Nav = get_parent().get_node("Navigation2D")
	#Line2D.hide()
	$ProgressBar.max_value = mobMaxHealth
	$ProgressBar.value = mobMaxHealth

func _physics_process(delta):
	$Line2D.global_position = Vector2.ZERO
#	vel = Target.global_position - self.global_position
#	vel = vel.normalized()
	var path:PoolVector2Array = Nav.get_simple_path(self.global_position, Target.global_position, true)
	$Line2D.points = path
	if path.size() > 1:
		distance = calcul_distance(path)
		vel = path[1] - self.position
		if distance < detection:
			move_and_slide(vel.normalized() * speed)
	else:
		print("nok")
		
	
	$ProgressBar.hide() if $ProgressBar.value == 100 else $ProgressBar.show()
	

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
