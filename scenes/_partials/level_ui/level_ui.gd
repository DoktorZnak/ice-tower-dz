extends Control

func _ready() -> void:
	$HBoxContainer/ProgressBar.max_value = GameManager.xp_needed
	$HBoxContainer/ProgressBar.value = GameManager.current_xp
	$HBoxContainer/levelLabel.text = str(GameManager.level)
	GameManager.xp_changed.connect(_on_xp_changed)
	GameManager.level_up_signal.connect(_on_level_up)

func _on_xp_changed(amount):
	update_progress_bar(GameManager.current_xp, GameManager.xp_needed)
	update_xp_label(amount)

func _on_level_up(new_level):
	$HBoxContainer/levelLabel.text = str(new_level)

func update_progress_bar(current_xp, xp_needed):
	$HBoxContainer/ProgressBar.max_value = xp_needed
	$HBoxContainer/ProgressBar.value = current_xp

func update_xp_label(amount):
	var xp_label = $XPLabel.duplicate()
	add_child(xp_label)
	xp_label.text = "+"+str(amount)
	xp_label.modulate.a = 1.0
	xp_label.visible = true
	
	var tween = create_tween().set_parallel(true)
	tween.tween_property(xp_label, 'position:y', xp_label.position.y - 35, 0.5).set_trans(Tween.TRANS_QUAD)
	tween.tween_property(xp_label, "modulate:a", 0.0, 1)
	tween.chain().tween_callback(Callable(xp_label, "queue_free"))
