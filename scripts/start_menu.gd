extends Control

@onready var button: Button = $Button
@onready var button_2: Button = $Button2
@onready var button_3: Button = $Button3

func _on_button_pressed() -> void:
	GameStats.current_difficulty = GameStats.Difficulty.EASY
	get_tree().change_scene_to_file("res://scenes/game.tscn")

func _on_button_2_pressed() -> void:
	GameStats.current_difficulty = GameStats.Difficulty.TUTORIAL
	get_tree().change_scene_to_file("res://scenes/game.tscn")

func _on_button_3_pressed() -> void:
	GameStats.current_difficulty = GameStats.Difficulty.HARD
	get_tree().change_scene_to_file("res://scenes/game.tscn")
