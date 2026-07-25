extends Node

var max_count := 100
var count_count := 0

#Stats to track, counts the imposter murdered, incorrect player guesses, imposters at large, remaining counts, time taken 

#probably nothin much here, just a label for the timer to next kill, game difficulty (num imposters, murder ranger, murder time)
# will probably figure out more as I make the game
var imposter_count := 1

func count_spawned():
	count_count += 1
