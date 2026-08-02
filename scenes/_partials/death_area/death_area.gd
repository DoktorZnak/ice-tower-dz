extends Area2D

var MIN_BOTTOM = 500

func on_game_level_change(game_level):
	print('ehre123')
	if game_level == 5 || game_level == 1: return
	var current_floor = GameManager.LEVEL_THRESHOLDS[game_level - 2]
	var y_px = -(current_floor * GameManager.LEVEL_PIXELS_TRESHOLD) + 50
	global_position.y = y_px
	EventBus.lava_moved.emit(y_px)

func _on_point_above_player_area_body_entered(_body):
	#return 
	$PointAbovePlayerArea.global_position.y -= 600
	var new_position = min($PointAbovePlayerArea.global_position.y + 1200, MIN_BOTTOM)
	
	global_position.y = new_position
	EventBus.lava_moved.emit(new_position)

func _on_death_area_body_entered(_body):
	get_tree().change_scene_to_file('res://scenes/game_over/game_over.tscn')

func _ready():
	EventBus.game_level_changed.connect(on_game_level_change)
	$PointAbovePlayerArea.global_position.y = -800
