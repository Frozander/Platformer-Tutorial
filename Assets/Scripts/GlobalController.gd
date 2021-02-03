extends Node

func _physics_process(_delta):
	if Input.is_action_just_pressed("ui_exit"):
		get_tree().quit()
