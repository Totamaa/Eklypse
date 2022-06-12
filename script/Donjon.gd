extends Node2D


var xpKill = 100


func _ready():
	add_child(Global.player)
#	$Player/Camera2D.current = false
	for node in get_children():
		print_debug(node)


#fonction des degats du mob
func hit(attacker: Player, damage : int):
	$ProgressBar.value -= damage
	
	# si l'ennemi n'a plus de vie
	if $ProgressBar.value <= 0:
		attacker.add_xp(xpKill)
		queue_free()
