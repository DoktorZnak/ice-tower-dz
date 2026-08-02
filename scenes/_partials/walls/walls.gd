extends TileMapLayer

@onready var main := get_owner() as MainScript

const TILE_SIZE_Y = 48
const BG_COLUMNS = 5
const SOURCE_ID = 0
var last_built_wall_y_tile = 0

const LEVEL_CONFIGS = {
	1: {"left": - 8, "right": 7},
	2: {"left": - 9, "right": 8},
	3: {"left": - 10, "right": 9},
	4: {"left": - 12, "right": 11},
	5: {"left": - 12, "right": 11}
}

var level_config = LEVEL_CONFIGS[1]
var game_level = 1

func build_wall_row(y_tile: int):
	var left_start = level_config["left"]
	var right_start = level_config["right"]
	
	set_cell(Vector2i(left_start, y_tile), SOURCE_ID, Vector2i(0, 0), TileSetAtlasSource.TRANSFORM_FLIP_H)
	set_cell(Vector2i(right_start, y_tile), SOURCE_ID, Vector2i(0, 0))
	
	for i in range(1, BG_COLUMNS + 1):
		set_cell(Vector2i(left_start - i, y_tile), SOURCE_ID, Vector2i(1, 0))

	for i in range(1, BG_COLUMNS + 1):
		set_cell(Vector2i(right_start + i, y_tile), SOURCE_ID, Vector2i(1, 0))

func build_walls_up_to(target_y_pixel):
	var target_tile_y = int(floor(target_y_pixel / TILE_SIZE_Y))

	if last_built_wall_y_tile == 0:
		build_wall_row(0)
	
	while last_built_wall_y_tile > target_tile_y:
		last_built_wall_y_tile -= 1
		build_wall_row(last_built_wall_y_tile)


func on_lava_moved(lava_y_pixel: float):
	var lava_tile_y = int(floor(lava_y_pixel / TILE_SIZE_Y)) + 2
	var used_cells = get_used_cells()
	for cell in used_cells:
		if cell.y > lava_tile_y:
			set_cell(cell, -1)

func on_highest_floor(highest_floor):
	if (is_next_level_close(highest_floor)):
		update_game_level(game_level + 1)
	var highest_floor_px = highest_floor * GameManager.LEVEL_PIXELS_TRESHOLD
	build_walls_up_to(- (highest_floor_px + (GameManager.LEVEL_PIXELS_TRESHOLD * 2)))

func update_game_level(new_level):
	level_config = LEVEL_CONFIGS[new_level]
	game_level = new_level

func is_next_level_close(highest_floor):
	if (game_level == 5): return false
	var isClose = (GameManager.LEVEL_THRESHOLDS[game_level - 1] - 1) == highest_floor
	return isClose


func _ready():
	EventBus.game_level_changed.connect(update_game_level)
	EventBus.lava_moved.connect(on_lava_moved)
	EventBus.highest_floor_changed.connect(on_highest_floor)
	for y in range(1, 7):
		build_wall_row(y)
	build_walls_up_to(- (GameManager.LEVEL_PIXELS_TRESHOLD * 2))
