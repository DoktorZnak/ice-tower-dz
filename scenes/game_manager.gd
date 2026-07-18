# GameManager.gd
extends Node

var stat_points: int = 40

var players_stats = {
	'acc': {'value': 200, 'label': 'Acceleration'},
	'maxspeed': {'value': 150, 'label': 'Speed'},
	'jump': {'value': 150, 'label': 'Jump'},
	'friction': {'value': 200, 'label': 'Friction'},
	'xp': {'value': 1, 'label': 'XP Bonus'},
}

func set_stat_point(stat_name, value):
	players_stats[stat_name]["value"] = value
	EventBus.stats_updated.emit()
