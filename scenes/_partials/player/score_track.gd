extends Node

var p: Player

var highest_score = 0
var pixels_treshold = 400

func update_players_stats():
	pixels_treshold = remap(GameManager.players_stats.xp.value, 1, 200, 400, 100)

func _ready():
	update_players_stats()
	EventBus.stats_updated.connect(update_players_stats)
	await owner.ready
	p = owner as Player

func _physics_process(_delta):
	var current_floor = int(abs(p.global_position.y) / pixels_treshold)
	if current_floor > highest_score:
		highest_score = current_floor
		EventBus.highest_score_changed.emit(highest_score)
