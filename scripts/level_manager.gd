extends Node

@onready var count_down: Label = $CountDown
@onready var murder_count_down: Timer = $MurderCountDown
@onready var button: Button = $Button

func _ready() -> void:
	#Based on the difficulty, change the imposter num and wait time
	match GameStats.current_difficulty:
		GameStats.Difficulty.TUTORIAL:
			print("Tutorial")
			GameStats.imposter_count = 2
			GameStats.murder_time = 3

		GameStats.Difficulty.EASY:
			print("Easy")
			GameStats.imposter_count = 1
			GameStats.murder_time = 10

		GameStats.Difficulty.HARD:
			print("Hard")
			GameStats.imposter_count = randi_range(2,5)
			GameStats.murder_time = 10
			
	murder_count_down.wait_time = GameStats.murder_time
	murder_count_down.start()
	
	# Reset stats for a new game
	GameStats.count_count = 0
	GameStats.time_elapsed = 0.0
	GameStats.counts_assassinated = 0
	GameStats.incorrect_guesses = 0
	GameStats.max_count = 100

func _process(delta: float) -> void:
	GameStats.time_elapsed += delta
	count_down.text = str(int(ceil(murder_count_down.time_left)))
	
func count_spawned():
	GameStats.count_count += 1

func count_killed():
	GameStats.count_count -= 1

func imposter_killed():
	GameStats.imposter_count -= 1

func incorrect_guess():
	GameStats.incorrect_guesses += 1 

func count_assassinated():
	GameStats.counts_assassinated += 1 

func _on_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/end_screen.tscn")
