extends Node

@onready var count_down: Label = $CountDown
@onready var murder_count_down: Timer = $MurderCountDown

#Stats to track, counts the imposter murdered, incorrect player guesses, imposters at large, remaining counts, time taken 
var max_count := 100
var count_count := 0
var imposter_count := 1

#probably nothin much here, just a label for the timer to next kill, game difficulty (num imposters, murder ranger, murder time)
# will probably figure out more as I make the game

func _process(delta: float) -> void:
	count_down.text = str(int(ceil(murder_count_down.time_left)))
	
func count_spawned():
	count_count += 1
