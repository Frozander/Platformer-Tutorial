extends Area2D

const V = 100;

var motion = Vector2()
var direction = 1

func _ready():
	$Sprite.play("fire")

func _physics_process(delta):
	motion.x = V * delta * direction
	translate(motion)
	

func _on_VisibilityNotifier2D_viewport_exited(_viewport):
	queue_free()
	
func _on_Fireball_body_entered(_body):
	queue_free()

func set_fireball_dir(dir):
	direction = dir
	if direction == -1:
		$Sprite.flip_h = true
