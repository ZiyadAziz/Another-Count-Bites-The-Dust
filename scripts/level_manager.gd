extends Node

var max_count := 100
var count_count := 0

#probably nothin much here, just a label for the timer to next kill, game difficulty (num imposters, murder ranger, murder time)
# will probably figure out more as I make the game
var imposter_count := 1

func count_spawned():
	count_count += 1
