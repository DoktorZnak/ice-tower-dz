# GameManager.gd
extends Node

signal xp_changed(amount)
signal level_up_signal(new_level)

var current_xp: int = 0
var xp_needed: int = 50
var level: int = 1
var stat_points: int = 40

var players_stats = {
	'acc': {'value': 200, 'label': 'Acceleration'},
	'maxspeed': {'value': 150, 'label': 'Speed'},
	'jump': {'value': 150, 'label': 'Jump'},
	'friction': {'value': 200, 'label': 'Friction'},
}

var base_speed = 200.0
var jump_force = -450.0

func set_stat_point(stat_name, value) -> bool:
	players_stats[stat_name]["value"] = value
	EventBus.stats_updated.emit()
	return true
	
	
func add_xp(amount):
	current_xp += amount
	if current_xp >= xp_needed:
		level_up(amount)
		xp_changed.emit(amount)
	else:
		xp_changed.emit(amount)

func level_up(amount):
	var diff = current_xp - xp_needed
	current_xp = diff
	level += 1
	stat_points += 3
	xp_needed = int(xp_needed * 1.5)
	level_up_signal.emit(level)
