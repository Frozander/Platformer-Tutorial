extends KinematicBody2D

const UP = Vector2(0, -1)
const G = 10
const V = 60
const J = -250

export(int) var hitpoints = 1

const FIREBALL = preload("res://Assets/Prefabs/Fireball.tscn")

var is_attacking = false
var is_on_ground = true
var is_dead = false
var motion = Vector2()

func _ready():
	var root = get_tree().get_root()
	var tilemap = root.get_child(root.get_child_count() - 1).get_node("TileMap")
	var cell_size = tilemap.cell_size.x
	$Camera2D.limit_left = tilemap.get_used_rect().position.x * cell_size
	$Camera2D.limit_right = tilemap.get_used_rect().end.x * cell_size

func _physics_process(_delta):
	if !is_dead:
		is_on_ground = is_on_floor()
		motion.y += G
		
		if Input.is_action_pressed("ui_right"):
			if !is_attacking || !is_on_ground:
				motion.x = V
				if !is_attacking:
					$Sprite.flip_h = false
					$Sprite.play("run")
					if sign($FireballLocation.position.x) == -1:
						$FireballLocation.position.x *= -1
		elif Input.is_action_pressed("ui_left"):
			if !is_attacking || !is_on_ground:
				motion.x = -V
				if !is_attacking:
					$Sprite.flip_h = true
					$Sprite.play("run")
					if sign($FireballLocation.position.x) == 1:
						$FireballLocation.position.x *= -1
		else:
			motion.x = 0
			if !is_attacking && is_on_ground:
				$Sprite.play("idle")
			
		if is_on_ground && !is_attacking:
			if Input.is_action_pressed("ui_up"):
				motion.y += J
		if !is_on_ground && !is_attacking:
			if motion.y < 0:
				$Sprite.play("jump")
			else:
				$Sprite.play("fall")
		
		if Input.is_action_just_pressed("ui_attack") && !is_attacking:
			if is_on_ground:
				motion.x = 0
			is_attacking = true
			$Sprite.play("slash")
			var fireball_instance = FIREBALL.instance()
			fireball_instance.position = $FireballLocation.global_position
			# While having if/else statement would look more readable
			# I prefer "possibly" faster logic to readable logic (Also tihs doesn't look that bad)
			fireball_instance.set_fireball_dir(sign($FireballLocation.position.x))
			get_parent().add_child(fireball_instance)
		
		if get_slide_count() > 0:
			for i in range(get_slide_count()):
				var collider = get_slide_collision(i).collider
				if "Enemy" in collider.name:
					motion.x += (position.x - collider.position.x) * 50
					hit(collider.damage)
		
		if hitpoints < 1:
			die()
		
		motion = move_and_slide(motion, UP)

func hit(damage):
	hitpoints -= damage

func die():
	is_dead = true
	motion = Vector2(0, 0)
	$Sprite.play("dead")
	$PlayerCollider.set_deferred("disabled", false)
	$Timer.start()

func return_to_title():
	var load_err = get_tree().change_scene("res://TitleScreen.tscn")
	if load_err:
		get_tree().quit()

func _on_Sprite_animation_finished():
	is_attacking = false

func _on_Timer_timeout():
	return_to_title()

func _on_VisibilityNotifier2D_viewport_exited(_viewport):
	return_to_title()
