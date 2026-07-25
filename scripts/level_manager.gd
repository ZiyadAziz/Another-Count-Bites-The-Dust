extends Node

@onready var count_down: Label = $CountDown
@onready var murder_count_down: Timer = $MurderCountDown

#In the tutorial the murder timer should be really short, so it would be easy to track the assassin, easy is just the default game, hard adds a variable number of imposters
enum Difficulty {TUTORIAL, EASY, HARD}

#Stats to track, counts the imposter murdered, incorrect player guesses, assassins at large, remaining counts, time taken 
var max_count := 100
var count_count := 0
var imposter_count := 1
var time_elapsed := 0.0
var counts_assassinated := 0
var incorrect_guesses := 0

func _ready() -> void:
	#Based on the difficulty, i'd the imposter num and wait time
	imposter_count = 1
	murder_count_down.wait_time = 10
	pass

func _process(delta: float) -> void:
	time_elapsed += delta
	count_down.text = str(int(ceil(murder_count_down.time_left)))
	
func count_spawned():
	count_count += 1

func count_killed():
	count_count -= 1

func imposter_killed():
	imposter_count -= 1

func incorrect_guess():
	incorrect_guesses += 1 

func count_assassinated():
	counts_assassinated += 1 
