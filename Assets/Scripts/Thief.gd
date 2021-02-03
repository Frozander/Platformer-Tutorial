extends KinematicBody2D

const UP = Vector2(0, -1)
const G = 10
const V = 30

var motion = Vector2()
var direction = 1
var is_dead = false

func _physics_process(_delta):
	if !is_dead:
		if is_on_wall() || !$LedgeDetector.is_colliding():
			change_dir()
		
		motion.x = V * direction
		motion.y += G
		$Sprite.play("walk")
		motion = move_and_slide(motion, UP)
		if get_slide_count() > 0:
			for i in range(get_slide_count()):
				if "Player" in get_slide_collision(i).collider.name:
					get_slide_collision(i).collider.die()

func change_dir():
	direction = direction * -1
	$Sprite.flip_h = !$Sprite.flip_h
	$LedgeDetector.position.x *= -1

func die():
	is_dead = true
	motion = Vector2(0, 0)
	$VanishTimer.start()
	$CollisionShape2D.set_deferred("disabled", true)
	$Sprite.play("dead")


func _on_VanishTimer_timeout():
	queue_free()
