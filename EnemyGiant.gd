extends KinematicBody2D

const UP = Vector2(0, -1)
const G = 20
const V = 100
const J = -300

var motion = Vector2()

func _physics_process(_delta):
	motion.y += G
	
#	if Input.is_action_pressed("ui_right"):
#		motion.x = V
#		$Sprite.flip_h = false
#		$Sprite.play("run")
#	elif Input.is_action_pressed("ui_left"):
#		motion.x = -V
#		$Sprite.flip_h = true
#		$Sprite.play("run")
#	else:
#		motion.x = 0
#		$Sprite.play("idle")
#
#	if is_on_floor():
#		if Input.is_action_just_pressed("ui_up"):
#			motion.y += J
#	else:
#		$Sprite.play("jump")
	
	motion = move_and_slide(motion, UP)
