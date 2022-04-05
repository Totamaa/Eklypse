extends PathFollow2D


func _physics_process(delta):
	self.global_position = Vector2(
		get_parent().get_parent().get_node("Player").position.x,
		get_parent().get_parent().get_node("Player").position.y
	)
