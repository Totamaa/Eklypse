extends Panel


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _on_Slot1_mouse_entered():
	emit_signal("mouse_entered", self)


func _on_Slot1_mouse_exited():
	emit_signal("mouse_exited", self)
