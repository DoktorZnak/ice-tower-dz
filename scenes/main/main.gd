class_name MainScript extends Node2D 


var platform_scene: PackedScene = preload("res://scenes/_partials/platform/platform.tscn")

const PLATFORM_SPACING = 120
const VIEWPORT_HEIGHT = 600
const BG_COLUMNS = 5

var current_game_lavel = 1 # 1-5
var next_spawn_y = -100
var platform_counter = 0

var is_game_over = false

func _ready() -> void:
	randomize()
	#last_built_wall_y_tile = next_spawn_y / TILE_SIZE_Y

func _physics_process(_delta):
	if is_game_over:
		return
		
	if Input.is_action_just_pressed("show_menu"):
		get_tree().change_scene_to_file('res://scenes/menu/menu.tscn')
		
	if Input.is_action_just_pressed("reset_game"):
		get_tree().reload_current_scene()
		
	if $Player.global_position.y < $Camera.global_position.y:
		$Camera.global_position.y = round($Player.global_position.y)

	var camera_top_y = $Camera.global_position.y - VIEWPORT_HEIGHT
	if next_spawn_y > camera_top_y:
		spawn_next_platform()
		addMainXP()
	
	clean_old_platforms($Camera.global_position.y + (VIEWPORT_HEIGHT / 2) - 100)
	#$Walls.clean_old_walls($Camera.global_position.y + (VIEWPORT_HEIGHT / 2) + 1000)

func _on_game_over_area_2d_body_entered():
	trigger_game_over()

func addMainXP():
	if(platform_counter % 10 == 0):
		GameManager.add_xp(14)


func spawn_next_platform():
	platform_counter += 1
	var new_platform = platform_scene.instantiate()
	new_platform.count = platform_counter
	new_platform.length = randi_range(11, 14)
	
	var platform_half_length = (new_platform.length * 22 / 2)

	var random_x = randf_range(-350 + platform_half_length, 350 - platform_half_length)
	new_platform.global_position = Vector2(random_x, next_spawn_y)
	$Platforms.add_child(new_platform)
	next_spawn_y -= PLATFORM_SPACING


func clean_old_platforms(cleanup_y):
	for platform in $Platforms.get_children():
		if platform.is_falling:
			continue
			
		if platform.global_position.y > cleanup_y:
			if platform.has_method("force_collapse"):
				platform.force_collapse()

func trigger_game_over():
	is_game_over = true
	var xp_earned = max(0, platform_counter - 2)
	
	GameManager.add_xp(xp_earned)
	
	print("Koniec gry! Zdobyte XP: ", xp_earned)
	get_tree().change_scene_to_file('res://scenes/menu/menu.tscn')
