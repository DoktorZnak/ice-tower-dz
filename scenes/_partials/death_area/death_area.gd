extends Area2D

var MIN_BOTTOM = 500

func on_game_level_change(game_level):
	if game_level == 1: return
	await get_tree().create_timer(0.5).timeout
	
	var current_floor = GameManager.LEVEL_THRESHOLDS[game_level - 2]
	var y_px = - (current_floor * GameManager.LEVEL_PIXELS_TRESHOLD) + 50
	global_position.y = y_px

func on_highest_floor(highest_floor):
	var highest_floor_px = highest_floor * GameManager.LEVEL_PIXELS_TRESHOLD
	var new_position = min(-(highest_floor_px - 500), MIN_BOTTOM)
	global_position.y = new_position
	EventBus.lava_moved.emit(new_position)

func _on_death_area_body_entered(_body):
	get_tree().change_scene_to_file('res://scenes/game_over/game_over.tscn')

func _ready():
	EventBus.game_level_changed.connect(on_game_level_change)
	EventBus.highest_floor_changed.connect(on_highest_floor)
