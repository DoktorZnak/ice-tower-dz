extends Control

func _ready():
	if(!GameManager.player_won):
		$GameWinLabel.text = 'You lose!'
	$PlatformCount.text = str(GameManager.platform_counter) +' Platforms'

func _on_button_pressed():
	GameManager.reset_stat_points()
	get_tree().change_scene_to_file("res://scenes/main/main.tscn")

func _process(_delta):
	if Input.is_action_just_pressed("reset_game"):
		GameManager.reset_stat_points()
		get_tree().change_scene_to_file("res://scenes/main/main.tscn")
