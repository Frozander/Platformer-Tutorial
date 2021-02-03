extends KinematicBody2D

const UP = Vector2(0, -1)
const G = 10
export(int) var hitpoints = 2
export(int) var V = 30
export(int) var damage = 1
export(Vector2) var size = Vector2(1, 1)

var motion = Vector2()
var direction = 1
var is_dead = false

func _ready():
	scale = size

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
					get_slide_collision(i).collider.hit(damage)
		
		if hitpoints < 1:
			die()

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
	if scale > Vector2(1, 1):
		get_parent().get_node("ScreenShake").screen_shake(1, 10, 100)

func hit(dmg):
	hitpoints -= dmg

func _on_VanishTimer_timeout():
	queue_free()
