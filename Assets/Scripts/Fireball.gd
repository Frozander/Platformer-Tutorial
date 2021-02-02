extends Area2D

const V = 100;

var motion = Vector2()

func _ready():
	$Sprite.play("fire")

func _physics_process(delta):
	motion.x = V * delta
	translate(motion)
	

func _on_VisibilityNotifier2D_viewport_exited(_viewport):
	queue_free()
