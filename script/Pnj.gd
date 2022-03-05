extends KinematicBody2D


# Fonction qui commence quand l'objet apparait pour la 1ère fois
func _ready():
	add_to_group("pnj")
	$animPnj.play("idle")
	$Sprite.flip_h = true
	


