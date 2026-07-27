# GameManager.gd
extends Node

var player_won = true

var players_stats = {
	'acc': {'value': 200, 'label': 'Acceleration'},
	'maxspeed': {'value': 200, 'label': 'Speed'},
	'jump': {'value': 200, 'label': 'Jump'},
	'friction': {'value': 200, 'label': 'Friction'},
	'xp': {'value': 1, 'label': 'XP Bonus'}
}

func set_stat_point(stat_name, value):
	players_stats[stat_name]["value"] = value
	EventBus.stats_updated.emit()

func reset_stat_points():
	players_stats = {
		'acc': {'value': 1, 'label': 'Acceleration'},
		'maxspeed': {'value': 1, 'label': 'Speed'},
		'jump': {'value': 1, 'label': 'Jump'},
		'friction': {'value': 1, 'label': 'Friction'},
		'xp': {'value': 1, 'label': 'XP Bonus'}
	}
