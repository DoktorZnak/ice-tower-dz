extends CanvasLayer

const ROMAN_NUMBER_SCENE = preload("res://scenes/_partials/game_level_ui/roman_number/roman_number.tscn")

func _ready():
	EventBus.game_level_changed.connect(on_game_level_change)

func on_game_level_change(level):
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
