extends Area2D


export var damage = 20 # degats de l'arme

onready var anim = $AnimationPlayer

func _ready():
	$CollisionShape2D.disabled = true

func attack():
	anim.play("attack")


func _on_Weapon_body_entered(body):
	if body.has_method("hit"):
		body.hit(get_parent(), damage + get_parent().degats)
