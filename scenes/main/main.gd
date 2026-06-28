extends Node2D

var platform_scene: PackedScene = preload("res://scenes/_partials/platform/platform.tscn")

const PLATFORM_SPACING = 120
const VIEWPORT_HEIGHT = 600
const TILE_SIZE_Y = 48 
const BG_COLUMNS = 5

var next_spawn_y = -100
var platform_counter = 0
var last_built_wall_y_tile = 0

var is_game_over = false

func _ready() -> void:
	randomize()
	for y in range(1, 7):
		build_wall_row(y)
		
	build_walls_up_to(-50)
	last_built_wall_y_tile = next_spawn_y / TILE_SIZE_Y

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
	clean_old_walls($Camera.global_position.y + (VIEWPORT_HEIGHT / 2) + 100)

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
	
	build_walls_up_to(next_spawn_y)
	
	next_spawn_y -= PLATFORM_SPACING

func build_walls_up_to(target_y_pixel: float):
	var target_tile_y = int(floor(target_y_pixel / TILE_SIZE_Y))
	
	if last_built_wall_y_tile == 0:
		build_wall_row(0)
	
	while last_built_wall_y_tile > target_tile_y:
		last_built_wall_y_tile -= 1
		build_wall_row(last_built_wall_y_tile)

func build_wall_row(y_tile: int):
	place_tile(-8, y_tile, Vector2i(0, 0), $LeftWall, TileSetAtlasSource.TRANSFORM_FLIP_H)
	
	place_tile(8, y_tile, Vector2i(0, 0), $RightWall)
	
	for i in range(1, BG_COLUMNS + 1):
		place_tile(-8 - i, y_tile, Vector2i(1, 0), $LeftWall)
		
	for i in range(1, BG_COLUMNS + 1):
		place_tile(8 + i, y_tile, Vector2i(1, 0), $RightWall)

func place_tile(tile_x: int, tile_y: int, atlas_coord: Vector2i, tilemap_node: TileMapLayer, alternative_tile: int = 0):
	tilemap_node.set_cell(Vector2i(tile_x, tile_y), 1, atlas_coord, alternative_tile)


func clean_old_platforms(cleanup_y):
	for platform in $Platforms.get_children():
		if platform.is_falling:
			continue
			
		if platform.global_position.y > cleanup_y:
			if platform.has_method("force_collapse"):
				platform.force_collapse()
				
func clean_old_walls(cleanup_y):
	var cleanup_tile_y = int(cleanup_y / TILE_SIZE_Y)
	$LeftWall.erase_cell(Vector2i(-8, cleanup_tile_y))
	$RightWall.erase_cell(Vector2i(8, cleanup_tile_y))
	
	for i in range(1, BG_COLUMNS + 1):
		$LeftWall.erase_cell(Vector2i(-8 - i, cleanup_tile_y))
		
	for i in range(1, BG_COLUMNS + 1):
		$RightWall.erase_cell(Vector2i(8 + i, cleanup_tile_y))

func trigger_game_over():
	is_game_over = true
	var xp_earned = max(0, platform_counter - 2)
	
	GameManager.add_xp(xp_earned)
	
	print("Koniec gry! Zdobyte XP: ", xp_earned)
	get_tree().change_scene_to_file('res://scenes/menu/menu.tscn')
