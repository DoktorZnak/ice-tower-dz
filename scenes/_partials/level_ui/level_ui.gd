extends Control

var random_xp = [1, 2, 3, 4, 5]
var current_xp = 0
var xp_needed = 50
var level = 1

func level_up():
	var diff = current_xp - xp_needed
	current_xp = diff
	level += 1
	xp_needed *= 1.5
	$HBoxContainer/levelLabel.text = str(level)
	EventBus.player_level_changed.emit(level)

func update_progress_bar():
	$HBoxContainer/ProgressBar.max_value = xp_needed
	$HBoxContainer/ProgressBar.value = current_xp

func update_xp_label(amount):
	var xp_label = $XPLabel.duplicate()
	add_child(xp_label)
	xp_label.text = "+" + str(amount)
	xp_label.modulate.a = 1.0
	xp_label.visible = true
	
	var tween = create_tween().set_parallel(true)
	tween.tween_property(xp_label, 'position:y', xp_label.position.y - 35, 0.5).set_trans(Tween.TRANS_QUAD)
	tween.tween_property(xp_label, "modulate:a", 0.0, 1)
	tween.chain().tween_callback(Callable(xp_label, "queue_free"))


func _highest_score_changed(_highest_score):
	var xp = random_xp.pick_random()
	current_xp += xp
	if current_xp >= xp_needed:
		level_up()
	update_progress_bar()
	update_xp_label(xp)


func _ready() -> void:
	$HBoxContainer/ProgressBar.max_value = GameManager.xp_needed
	$HBoxContainer/ProgressBar.value = GameManager.current_xp
	$HBoxContainer/levelLabel.text = str(GameManager.level)
	EventBus.highest_score_changed.connect(_highest_score_changed)
