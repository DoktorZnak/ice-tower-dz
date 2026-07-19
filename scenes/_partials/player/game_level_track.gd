extends Node

var p: Player

const LEVEL_THRESHOLDS = [10, 20, 30, 40]

var game_score = 0
var current_game_level = 0
var pixels_treshold = 400

func check_level_up(score):
	var new_level = 1
	for i in range(LEVEL_THRESHOLDS.size()):
		if score > LEVEL_THRESHOLDS[i]:
			new_level = i + 2
	if new_level > current_game_level:
		current_game_level = new_level
		EventBus.game_level_changed.emit(current_game_level)
		
func _ready():
	await owner.ready
	p = owner as Player

func _physics_process(_delta):
	var current_floor = int(abs(p.global_position.y) / pixels_treshold)
	if current_floor > game_score:
		game_score = current_floor
		check_level_up(game_score)
