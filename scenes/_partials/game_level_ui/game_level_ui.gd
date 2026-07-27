extends CanvasLayer

const ROMAN_NUMBER_SCENE = preload("res://scenes/_partials/game_level_ui/roman_number/roman_number.tscn")

func count_down():
	$Timer.start()
	$TimerLabel.visible = true
	set_process(true)
	
func on_game_level_change(level):
	if level == 5:	
		count_down()
	for child in %HBoxContainer.get_children():
		child.queue_free()

	var count = 0
	if level >= 1 and level <= 3:
		count = level      
	elif level == 4:
		count = 2         
	elif level == 5:
		count = 1       

	for i in range(count):
		var instance = ROMAN_NUMBER_SCENE.instantiate()
		if level == 4:
			instance.number = "1" if i == 0 else "5"
		else:instance.number = "1" if level <= 3 else "5"
		%HBoxContainer.add_child(instance)

func _on_timer_timeout():
	GameManager.player_won = true
	get_tree().change_scene_to_file('res://scenes/game_over/game_over.tscn')

func _ready():
	EventBus.game_level_changed.connect(on_game_level_change)
	set_process(false)

func _process(_delta):
	$TimerLabel.text = String.num($Timer.time_left, 2)
