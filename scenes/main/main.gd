class_name MainScript extends Node2D

var is_game_over = false

func _ready():
	randomize()
	EventBus.player_level_changed.connect(on_player_level_up)
	EventBus.game_level_changed.emit(1)

# func _process(_delta):
	# if Input.is_action_just_pressed("reset_game"):
	# 	GameManager.reset_stat_points()
	# 	get_tree().reload_current_scene()

	#if Input.is_action_just_pressed('pause'):
		#$UpgradeCards.open_upgrade_menu()
		
func on_player_level_up(_new_level):
	$UpgradeCards.open_upgrade_menu()
