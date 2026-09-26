# GameManager.gd
extends Node

var player_won = false
var is_first_launch = true # game starts on the game over screen as a start screen
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

var touch_used = false # shows on-screen buttons

func _input(event):
	# Browsers can't be trusted to report a touchscreen, so show the buttons after a real touch
	if event is InputEventScreenTouch:
		touch_used = true
	elif event is InputEventKey and (event.is_action_pressed("left") or event.is_action_pressed("right") or event.is_action_pressed("jump")):
		touch_used = false

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
