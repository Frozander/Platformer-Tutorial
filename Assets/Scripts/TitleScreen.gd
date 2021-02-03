extends Node

func _ready():
	$MarginContainer/VBoxContainer/VBoxContainer/StartButton.grab_focus()

func _physics_process(_delta):
	if $MarginContainer/VBoxContainer/VBoxContainer/StartButton.is_hovered():
		$MarginContainer/VBoxContainer/VBoxContainer/StartButton.grab_focus()
	if $MarginContainer/VBoxContainer/VBoxContainer/ExitButton.is_hovered():
		$MarginContainer/VBoxContainer/VBoxContainer/ExitButton.grab_focus()
		


func _on_StartButton_pressed():
	var load_err = get_tree().change_scene("res://StageOne.tscn")
	if load_err:
		get_tree().quit()
	
func _on_ExitButton_pressed():
	get_tree().quit()
