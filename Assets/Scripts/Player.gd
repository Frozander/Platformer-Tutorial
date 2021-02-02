extends KinematicBody2D

const UP = Vector2(0, -1)
const G = 10
const V = 60
const J = -250

const FIREBALL = preload("res://Assets/Prefabs/Fireball.tscn")

var is_attacking = false
var is_on_ground = true
var motion = Vector2()

func _physics_process(_delta):
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
	
	motion = move_and_slide(motion, UP)

func _on_Sprite_animation_finished():
	is_attacking = false
