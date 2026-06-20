extends Control

func _ready():
	$HBoxContainer/AvailablePointsLabel.text = str(GameManager.stat_points)

func _on_play_pressed() -> void:
	get_tree().change_scene_to_file('res://scenes/main/main.tscn')
