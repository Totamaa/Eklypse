extends Area2D


func _ready():
	$ProgressBar.max_value = $Timer.wait_time

func _physics_process(delta):
	$ProgressBar.value = $Timer.wait_time - $Timer.time_left
	if $ProgressBar.value < $ProgressBar.max_value:
		$ProgressBar.show()
	else:
		$ProgressBar.hide()

func _on_tp_area_entered(area):
	$Timer.start()
	
func _on_tp_area_exited(area):
	$Timer.stop()


func _on_Timer_timeout():
	get_tree().change_scene("res://scene/Donjon.tscn")
