# GameManager.gd
extends Node

var current_xp: int = 0
var xp_needed: int = 10
var level: int = 1
var stat_points: int = 0

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
