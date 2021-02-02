extends KinematicBody2D

const UP = Vector2(0, -1)
const G = 10
const V = 30

var motion = Vector2()
var direction = 1

func _ready():
	pass

func _physics_process(_delta):
	
	if is_on_wall() || !$LedgeDetector.is_colliding():
		change_dir()
	
	motion.x = V * direction
	motion.y += G
	$Sprite.play("walk")
	motion = move_and_slide(motion, UP)

func change_dir():
	direction = direction * -1
	$Sprite.flip_h = !$Sprite.flip_h
	$LedgeDetector.position.x *= -1
