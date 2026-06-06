extends Node2D

var platform_scene: PackedScene = preload("res://scenes/platform/platform.tscn")

const PLATFORM_SPACING = 80
const VIEWPORT_HEIGHT = 600
const TILE_SIZE_Y = 32

var next_spawn_y = -100
var platform_counter = 0
var last_built_wall_y_tile = 0

var is_game_over = false

func _ready() -> void:
	randomize()
	last_built_wall_y_tile = next_spawn_y / TILE_SIZE_Y

func _physics_process(_delta):
	if is_game_over:
		return
		
	if Input.is_action_just_pressed("reset_game"):
		get_tree().reload_current_scene()
		
	if $Player.global_position.y < $Camera.global_position.y:
		$Camera.global_position.y = round($Player.global_position.y)

	var camera_top_y = $Camera.global_position.y - VIEWPORT_HEIGHT
	if next_spawn_y > camera_top_y:
		spawn_next_platform()
	
	clean_old_platforms($Camera.global_position.y + (VIEWPORT_HEIGHT / 2) - 100)
	clean_old_walls($Camera.global_position.y + (VIEWPORT_HEIGHT / 2) + 50)

func spawn_next_platform():
	platform_counter += 1
	var new_platform = platform_scene.instantiate()
	new_platform.count = platform_counter
	new_platform.length = randi_range(15, 20)
	
	var platform_half_length = (new_platform.length * 16 / 2)

	var random_x = randf_range(-350 + platform_half_length, 350 - platform_half_length)
	new_platform.global_position = Vector2(random_x, next_spawn_y)
	$Platforms.add_child(new_platform)
	
	build_walls_up_to(next_spawn_y)
	
	next_spawn_y -= PLATFORM_SPACING

func build_walls_up_to(target_y_pixel: float):
	var target_tile_y = int(target_y_pixel / TILE_SIZE_Y)
	
	while last_built_wall_y_tile > target_tile_y:
		last_built_wall_y_tile -= 1
		place_wall_tile(-12, last_built_wall_y_tile, $LeftWall)
		place_wall_tile(11, last_built_wall_y_tile, $RightWall)

func place_wall_tile(tile_x: int, tile_y: int, tilemap_node: TileMapLayer):
	var frame_y_offset = 5 if randf() < 0.85 else randi() % 5
	var atlas_coord = Vector2i(0, frame_y_offset)
	tilemap_node.set_cell(Vector2i(tile_x, tile_y), 0, atlas_coord)


func clean_old_platforms(cleanup_y):
	for platform in $Platforms.get_children():
		if platform.is_falling:
			continue
			
		if platform.global_position.y > cleanup_y:
			if platform.has_method("force_collapse"):
				platform.force_collapse()
				
func clean_old_walls(cleanup_y):
	var cleanup_tile_y = int(cleanup_y / TILE_SIZE_Y)
	for x in [-12, 11]:
		$LeftWall.erase_cell(Vector2i(-12, cleanup_tile_y))
		$RightWall.erase_cell(Vector2i(11, cleanup_tile_y))

func trigger_game_over():
	is_game_over = true
	var xp_earned = max(0, platform_counter - 2)
	
	GameManager.add_xp(xp_earned)
	
	print("Koniec gry! Zdobyte XP: ", xp_earned)
	get_tree().change_scene_to_file('res://scenes/menu/menu.tscn')


func _on_area_2d_body_entered(_body: Node2D):
	trigger_game_over()
