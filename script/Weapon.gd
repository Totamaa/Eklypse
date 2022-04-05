extends Area2D


export var damage = 50      #degats de base  pour test

onready var anim = $AnimationPlayer

func attack():
	anim.play("attack")
	print("j'ai attaqué wesh")


func _on_Weapon_body_entered(body):
	if body.has_method("hit"):
		body.hit(damage)
		print("degats")
