extends Control

@onready var prompt = $PromptLabel
@onready var result = $ResultLabel
@onready var player_hp_label = $PlayerHPLabel
@onready var enemy_hp_label = $EnemyHPLabel

@onready var enemy_sprite = $EnemySprite
@onready var enemy_name = $EnemyNameLabel
@onready var player_name = $PlayerNameLabel
@onready var b1 = $ChoiceButton1
@onready var b2 = $ChoiceButton2
@onready var b3 = $ChoiceButton3
@onready var b4 = $ChoiceButton4

var player_hp = 30
var enemy_hp = 30
var correct_answer = ""





var trainer_1_questions = [
	{"jp":"あ","answer":"a","choices":["a","i","u","e"]},
	{"jp":"い","answer":"i","choices":["a","i","u","e"]},
	{"jp":"う","answer":"u","choices":["a","i","u","e"]},
	{"jp":"え","answer":"e","choices":["a","i","u","e"]},
	{"jp":"お","answer":"o","choices":["o","a","i","u"]}
]

var trainer_2_questions = [
	{"jp":"か","answer":"ka","choices":["ka","ki","ku","ke"]},
	{"jp":"き","answer":"ki","choices":["ka","ki","ku","ke"]},
	{"jp":"く","answer":"ku","choices":["ka","ki","ku","ke"]},
	{"jp":"け","answer":"ke","choices":["ka","ki","ku","ke"]},
	{"jp":"こ","answer":"ko","choices":["ko","ka","ki","ku"]}
]

var questions = []



func _ready():
	result.text = ""
	enemy_name.text = "Trainer"
	
	
	

	if GameState.current_trainer == 1:
		questions = trainer_1_questions
		enemy_hp_label.text = "Trainer 1 HP: " + str(enemy_hp)
	else:
		questions = trainer_2_questions
		enemy_hp_label.text = "Trainer 2 HP: " + str(enemy_hp)

	if GameState.current_trainer == 1:
		enemy_sprite.texture = preload("res://rpgsprites1/townfolk1_f.png")
	elif GameState.current_trainer == 2:
		enemy_sprite.texture = preload("res://rpgsprites1/townfolk1_m.png")
	
	b1.pressed.connect(func(): check_answer(b1.text))
	b2.pressed.connect(func(): check_answer(b2.text))
	b3.pressed.connect(func(): check_answer(b3.text))
	b4.pressed.connect(func(): check_answer(b4.text))



	update_hp_labels()
	next_question()

func next_question():
	var current_question = questions.pick_random()

	prompt.text = "What is: " + current_question["jp"] + " ?"
	correct_answer = current_question["answer"]

	var choices = current_question["choices"].duplicate()
	choices.shuffle()

	b1.text = choices[0]
	b2.text = choices[1]
	b3.text = choices[2]
	b4.text = choices[3]

func check_answer(answer):
	if answer == correct_answer:
		enemy_hp -= 10
		result.text = "Correct! Enemy took damage!"
	else:
		player_hp -= 10
		result.text = "Wrong! You took damage!"

	update_hp_labels()

	if enemy_hp <= 0:
		result.text = "You Win!"

		if GameState.current_trainer == 1:
			GameState.trainer_1_defeated = true
		else:
			GameState.trainer_2_defeated = true

		await get_tree().create_timer(2.0).timeout
		get_tree().change_scene_to_file("res://Main.tscn")
		return

	if player_hp <= 0:
		result.text = "You Lose!"
		await get_tree().create_timer(2.0).timeout
		get_tree().change_scene_to_file("res://Main.tscn")
		return

	await get_tree().create_timer(1.0).timeout
	result.text = ""
	next_question()

func update_hp_labels():
	player_hp_label.text = "Player HP: " + str(player_hp)

	if GameState.current_trainer == 1:
		enemy_hp_label.text = "Trainer 1 HP: " + str(enemy_hp)
	else:
		enemy_hp_label.text = "Trainer 2 HP: " + str(enemy_hp)
