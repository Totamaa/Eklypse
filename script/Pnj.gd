extends KinematicBody2D


func _ready():
	add_to_group("pnj")
	$animPnj.play("idle")
	$Sprite.flip_h = true
	


