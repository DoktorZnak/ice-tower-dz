# GameManager.gd
extends Node

var player_won = false

var players_stats = {
	'acc': {'value': 50, 'label': 'Acceleration'},
	'maxspeed': {'value': 50, 'label': 'Speed'},
	'jump': {'value': 50, 'label': 'Jump'},
	'friction': {'value': 50, 'label': 'Friction'},
	'xp': {'value': 50, 'label': 'XP Bonus'}
}

func set_stat_point(stat_name, value):
	players_stats[stat_name]["value"] = value
	EventBus.stats_updated.emit()

func reset_stat_points():
	player_won = false
	players_stats = {
		'acc': {'value': 1, 'label': 'Acceleration'},
		'maxspeed': {'value': 1, 'label': 'Speed'},
		'jump': {'value': 1, 'label': 'Jump'},
		'friction': {'value': 1, 'label': 'Friction'},
		'xp': {'value': 1, 'label': 'XP Bonus'}
	}
