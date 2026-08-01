extends Control

var random_xp = [1, 1.5, 2, 2.5, 3, 3.5, 4, 4.5, 5, 5.5, 6, 6.5]
var current_xp = 0
var xp_needed = 203200
var level = 1

var xp_bonus = 1

func update_players_stats():
	xp_bonus = remap(GameManager.players_stats.xp.value, 1, 200, 1, 5)

func level_up():
	var diff = current_xp - xp_needed
	current_xp = diff
	level += 1
	xp_needed *= 1.2
	$HBoxContainer/levelLabel.text = str(level)
	EventBus.player_level_changed.emit(level)

func update_progress_bar():
	$HBoxContainer/ProgressBar.max_value = xp_needed
	$HBoxContainer/ProgressBar.value = current_xp

func update_xp_label(amount):
	var xp_label = $XPLabel.duplicate()
	add_child(xp_label)
	xp_label.text = "+" + str(amount).trim_suffix(".0")
	xp_label.modulate.a = 1.0
	xp_label.visible = true
	
	var tween = create_tween().set_parallel(true)
	tween.tween_property(xp_label, 'position:y', xp_label.position.y - 35, 0.5).set_trans(Tween.TRANS_QUAD)
	tween.tween_property(xp_label, "modulate:a", 0.0, 1)
	tween.chain().tween_callback(Callable(xp_label, "queue_free"))


func _highest_score_changed(_highest_score):
	var xp = snapped(random_xp.pick_random() * xp_bonus, 0.01)
	current_xp += xp
	if current_xp >= xp_needed:
		level_up()
	update_progress_bar()
	update_xp_label(xp)

func _ready() -> void:
	update_players_stats()
	EventBus.stats_updated.connect(update_players_stats)
	$HBoxContainer/ProgressBar.max_value = xp_needed
	$HBoxContainer/ProgressBar.value = current_xp
	$HBoxContainer/levelLabel.text = str(level)
	EventBus.highest_score_changed.connect(_highest_score_changed)
