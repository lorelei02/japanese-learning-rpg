extends CharacterBody2D

@onready var sprite = $AnimatedSprite2D

@export var speed := 200.0

func _physics_process(_delta):
	var direction = Vector2.ZERO

	if Input.is_action_pressed("ui_right"):
		direction.x += 1
	if Input.is_action_pressed("ui_left"):
		direction.x -= 1
	if Input.is_action_pressed("ui_down"):
		direction.y += 1
	if Input.is_action_pressed("ui_up"):
		direction.y -= 1

	velocity = direction.normalized() * speed

	if direction.x > 0:
		sprite.play("walk_right")
	
	elif direction.x < 0:
		sprite.play("walk_left")
		
	elif direction.y > 0:
		sprite.play("walk_down")
		
	elif direction.y < 0:
		sprite.play("walk_up")
	
	else:
		sprite.stop()
		
	move_and_slide()
