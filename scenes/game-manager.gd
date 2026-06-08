# GameManager.gd
extends Node

var current_xp: int = 0
var xp_needed: int = 10
var level: int = 1
var stat_points: int = 40

var players_stats = {
	'acc': {'value': 100, 'label': 'Acceleration'},
	'maxspeed': {'value': 100, 'label': 'Max Speed'},
	'jump': {'value': 3, 'label': 'Jump'},
	'friction': {'value': 100, 'label': 'Friction'},
	#'wall_bounce': {'value': 1.2, 'label': 'Wall Bounce Multiplier'},
	#'combo': {'value': 0, 'label': 'Current Combo Counter'}
}

var base_speed: float = 200.0
var jump_force: float = -450.0

func add_xp(amount: int) -> void:
	current_xp += amount
	if current_xp >= xp_needed:
		level_up()

func level_up() -> void:
	current_xp -= xp_needed
	level += 1
	stat_points += 3
	xp_needed = int(xp_needed * 1.5)
	print("Awans! Poziom: ", level, " Punkty: ", stat_points)


func add_stat_point(stat_name: String) -> bool:
	if stat_points <= 0: return false
	if players_stats[stat_name]["value"] >= 100: return false

	stat_points -= 1
	players_stats[stat_name]["value"] += 1
	return true
