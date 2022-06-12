extends KinematicBody2D

export var hp = 4000
export var speed = 300
export var attack = 50

func _ready():
	add_to_group("enemy")
	$CanvasLayer/BossHP.max_value = hp


func update_display():
	$CanvasLayer/BossHP.value = hp 

#fonction des degats du mob
func hit(attacker: Player, damage : int):
	hp -= damage
	update_display()
	if hp <= 0:
		queue_free()


