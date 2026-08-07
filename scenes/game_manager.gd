# GameManager.gd
extends Node

var player_won = false
const LEVEL_THRESHOLDS = [30, 50, 65, 90]
const LEVEL_PIXELS_TRESHOLD = 600
var platform_counter = 1

var players_stats = {
	'acc': {'value': 1, 'label': 'Acceleration'},
	'maxspeed': {'value': 1, 'label': 'Speed'},
	'jump': {'value': 1, 'label': 'Jump'},
	'friction': {'value': 1, 'label': 'Friction'},
	'xp': {'value': 1, 'label': 'XP Bonus'}
}

var PLAYERS_STATS_MAX = {
	'acc': 400,
	'maxspeed': 400,
	'jump': 400,
	'friction': 400,
	'xp': 400
}

func set_stat_point(stat_name, value):
	players_stats[stat_name]["value"] = value
	EventBus.stats_updated.emit()

func reset_stat_points():
	player_won = false
	platform_counter = 1
	players_stats = {
		'acc': {'value': 1, 'label': 'Acceleration'},
		'maxspeed': {'value': 1, 'label': 'Speed'},
		'jump': {'value': 1, 'label': 'Jump'},
		'friction': {'value': 1, 'label': 'Friction'},
		'xp': {'value': 1, 'label': 'XP Bonus'}
	}
