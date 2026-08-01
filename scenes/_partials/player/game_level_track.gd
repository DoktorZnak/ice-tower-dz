extends Node

var p: Player

var highest_floor = 0
var current_game_level = 1

func check_level_up(new_floor):
	var new_level = 1
	for i in range(GameManager.LEVEL_THRESHOLDS.size()):
		if new_floor >= GameManager.LEVEL_THRESHOLDS[i]:
			new_level = i + 2
	if new_level > current_game_level:
		current_game_level = new_level
		EventBus.game_level_changed.emit(current_game_level)
		
func _ready():
	await owner.ready
	p = owner as Player

func _physics_process(_delta):
	var current_floor = int(abs(p.global_position.y) / GameManager.LEVEL_PIXELS_TRESHOLD)
	if current_floor > highest_floor:
		highest_floor = current_floor
		EventBus.highest_floor_changed.emit(highest_floor)
		check_level_up(highest_floor)
