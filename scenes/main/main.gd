class_name MainScript extends Node2D

var is_game_over = false

func _ready():
	randomize()
	EventBus.game_level_changed.emit(5)

func _process(_delta): # it doesnt need to be a physic process
	if is_game_over:
		return
		
	if Input.is_action_just_pressed("reset_game"):
		get_tree().reload_current_scene()
	
	if Input.is_action_just_pressed('pause'):
		$UpgradeCards.open_upgrade_menu()
		
func trigger_game_over():
	is_game_over = true
	get_tree().change_scene_to_file('res://scenes/menu/menu.tscn')
