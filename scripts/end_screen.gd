extends Control

@onready var button: Button = $Button

@onready var label: Label = $Label
@onready var label_2: Label = $Label2
@onready var label_3: Label = $Label3
@onready var label_4: Label = $Label4
@onready var label_5: Label = $Label5
@onready var label_6: Label = $Label6

func _ready() -> void:
	label_5.text = "Final Time: " + str(int(GameStats.time_elapsed))
	label_3.text = "Assassins at Large: " + str(GameStats.imposter_count)
	label_4.text = "Remaining Counts: " + str(GameStats.count_count)
	label.text = "Counts Murdered by Assassin: " + str(GameStats.counts_assassinated)
	label_2.text = "Counts Murdered by Player: " + str(GameStats.incorrect_guesses)
	label_6.text = "Assassins Killed By Player: " + str(GameStats.correct_guesses)

func _on_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/start_menu.tscn")
