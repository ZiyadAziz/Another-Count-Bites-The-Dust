extends Node

enum Difficulty {TUTORIAL, EASY, HARD}
var current_difficulty := Difficulty.EASY

var murder_time = 10

# Game stats that I need to pass to other scenes
var max_count := 100
var count_count := 0
var imposter_count := 1
var time_elapsed := 0.0
var counts_assassinated := 0
var incorrect_guesses := 0
