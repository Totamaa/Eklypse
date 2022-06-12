extends KinematicBody2D

export var hp = 2000
export var speed = 300
export var attack = 50

func _ready():
	add_to_group("enemy")
	$CanvasLayer/BossHP.max_value = hp


func update_display():
	$CanvasLayer/BossHP.value = hp 

