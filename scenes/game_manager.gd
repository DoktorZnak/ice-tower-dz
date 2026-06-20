# GameManager.gd
extends Node

signal xp_changed(amount)
signal level_up_signal(new_level)

var current_xp: int = 0
var xp_needed: int = 50
var level: int = 1
var stat_points: int = 40

var players_stats = {
	'acc': {'value': 100, 'label': 'Acceleration'},
	'maxspeed': {'value': 100, 'label': 'Max Speed'},
	'jump': {'value': 100, 'label': 'Jump'},
	'friction': {'value': 100, 'label': 'Friction'},
}

var base_speed: float = 200.0
var jump_force: float = -450.0

func add_stat_point(stat_name: String) -> bool:
	if stat_points <= 0: return false
	if players_stats[stat_name]["value"] >= 100: return false

	stat_points -= 1
	players_stats[stat_name]["value"] += 1
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
