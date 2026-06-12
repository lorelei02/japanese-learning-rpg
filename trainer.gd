extends Area2D

@export var interact_distance := 200.0

var player

func _ready():
	if GameState.trainer_1_defeated:
		queue_free()
		return
		
	player = get_tree().current_scene.find_child("Player", true, false)

func _process(_delta):
	if player == null:
		return

	var distance = global_position.distance_to(player.global_position)

	if distance < interact_distance:
		if Input.is_action_just_pressed("ui_accept"):
			GameState.current_trainer = 1
			get_tree().change_scene_to_file("res://battle.tscn")
