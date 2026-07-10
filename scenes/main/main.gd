class_name MainScript extends Node2D 

var current_game_level = 5 # 1-5
var is_game_over = false

func _ready():
	randomize()

func _physics_process(_delta):
	if is_game_over:
		return
		
	if Input.is_action_just_pressed("reset_game"):
		get_tree().reload_current_scene()
	
	if Input.is_action_just_pressed('pause'):
		get_tree().paused = true
		
func trigger_game_over():
	is_game_over = true
	get_tree().change_scene_to_file('res://scenes/menu/menu.tscn')
