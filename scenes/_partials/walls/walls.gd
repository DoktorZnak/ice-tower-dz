extends TileMapLayer

@onready var main := get_owner() as MainScript

const TILE_SIZE_Y = 16
const BG_COLUMNS = 5
const SOURCE_ID = 0
var last_built_wall_y_tile = 0

const LEVEL_CONFIGS = {
	1: {"left": - 8, "right": 7},
	2: {"left": - 9, "right": 8},
	3: {"left": - 10, "right": 9},
	4: {"left": - 11, "right": 10},
	5: {"left": - 12, "right": 11}
}

var level_config = LEVEL_CONFIGS[1]

func build_wall_row(y_tile: int):
	var left_start = level_config["left"]
	var right_start = level_config["right"]
	
	set_cell(Vector2i(left_start, y_tile), SOURCE_ID, Vector2i(0, 0), TileSetAtlasSource.TRANSFORM_FLIP_H)
	set_cell(Vector2i(right_start, y_tile), SOURCE_ID, Vector2i(0, 0))
	
	for i in range(1, BG_COLUMNS + 1):
		set_cell(Vector2i(left_start - i, y_tile), SOURCE_ID, Vector2i(1, 0))

	for i in range(1, BG_COLUMNS + 1):
		set_cell(Vector2i(right_start + i, y_tile), SOURCE_ID, Vector2i(1, 0))

func build_walls_up_to(target_y_pixel: float):
	var target_tile_y = int(floor(target_y_pixel / TILE_SIZE_Y))
	
	if last_built_wall_y_tile == 0:
		build_wall_row(0)
	
	while last_built_wall_y_tile > target_tile_y:
		last_built_wall_y_tile -= 1
		build_wall_row(last_built_wall_y_tile)

func update_game_level(new_level):
	level_config = LEVEL_CONFIGS[new_level]

func _ready() -> void:
	EventBus.game_level_changed.connect(update_game_level)
	for y in range(1, 7):
		build_wall_row(y)
	build_walls_up_to(-200)
	$Area2D.global_position.y = -200

func _on_area_2d_body_entered(_body):
	$Area2D.global_position.y -= 600
	build_walls_up_to($Area2D.global_position.y)
	#clean_old_walls()


#func clean_old_walls(target_y_pixel: float):
	#var target_tile_y = int(floor(target_y_pixel / TILE_SIZE_Y))
	#
	#var start_x = -12 - BG_COLUMNS
	#var end_x = 11 + BG_COLUMNS
	#
	#for x_tile in range(start_x, end_x + 1):
		#erase_cell(Vector2i(x_tile, target_tile_y))
