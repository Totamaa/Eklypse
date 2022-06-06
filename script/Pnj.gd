extends KinematicBody2D

var quete = 0 
# 0: rien, 1: tuto, 2: tuer 10 monstres, 3: tuer le boss

var tutoDone = false
var missionDone = false

# Fonction qui commence quand l'objet apparait pour la 1ère fois
func _ready():
	add_to_group("pnj")
	$animPnj.play("idle")
	$Sprite.flip_h = true
	

func _on_Area2D_body_entered(body):
	if body.is_in_group("player"):
		$DialoguePNJ/ColorRect.show()
		get_tree().paused = true
		# première rencontre avec le pnj
		if quete == 0:
			$CenterContainer/Label.set_text("...")
			quete += 1
			$DialoguePNJ/Tuto.show()
			
		# faire le tuto
		elif quete == 1:
			if tutoDone:
				quete += 1
				$DialoguePNJ/Mission.show()
			else:
				$CenterContainer/Label.set_text("...")
				$DialoguePNJ/Wait.show()
				
		# faire la mission
		elif quete == 2:
			if missionDone:
				quete +=1
				$CenterContainer/Label.set_text("...")
				$DialoguePNJ/Boss.show()
			else:
				$CenterContainer/Label.set_text("...")
				$DialoguePNJ/Wait.show()
		
		# tuer le boss
		elif quete == 3:
			$CenterContainer/Label.set_text("...")


func _on_DialoguePNJ_buttonPressed():
	get_tree().paused = false
	$DialoguePNJ/ColorRect.hide()
	$DialoguePNJ/Boss.hide()
	$DialoguePNJ/Mission.hide()
	$DialoguePNJ/Wait.hide()
	$DialoguePNJ/Tuto.hide()
