extends Node2D

var platform_scene: PackedScene = preload("res://scenes/_partials/platform_builder/platform/platform.tscn")
@onready var main := get_owner() as MainScript

var platform_counter = 1

const LEVEL_CONFIGS = {
	1: {'center_offset': 350, 'platform_spacing': 100, 'length_min': 11, 'length_max': 18},
	2: {'center_offset': 398, 'platform_spacing': 110, 'length_min': 11, 'length_max': 18},
	3: {'center_offset': 446, 'platform_spacing': 120, 'length_min': 11, 'length_max': 18},
	4: {'center_offset': 494, 'platform_spacing': 150, 'length_min': 11, 'length_max': 18},
	5: {'center_offset': 542, 'platform_spacing': 250, 'length_min': 4, 'length_max': 14}
}

var level_config = LEVEL_CONFIGS[1]
var game_level = 1

func spawn_platform(spawn_y, full_width = false):
	platform_counter += 1
	var new_platform = platform_scene.instantiate() as Platform
	new_platform.count = platform_counter
	new_platform.length = 70 if full_width == true else randi_range(level_config['length_min'], level_config['length_max'])
	new_platform.game_level = game_level
	
	var platform_half_length_px = ((new_platform.length / 2) - 2) * 16

	var center_offset = level_config['center_offset']

	var random_x = (-center_offset + platform_half_length_px) if full_width == true else randf_range(-center_offset + platform_half_length_px, center_offset - platform_half_length_px)
	new_platform.global_position = Vector2(random_x, spawn_y)
	$Platforms.add_child(new_platform)

func spawn_platforms(from_px, to_px):
	var distant = abs(to_px) - abs(from_px)
	var platform_count_to_create = round(distant / level_config['platform_spacing'])
	var platform_spacing = distant / platform_count_to_create
	for y in range(0, platform_count_to_create):
		var offset_from_px = platform_spacing * y
		spawn_platform(from_px - offset_from_px)

func update_game_level(new_level):
	level_config = LEVEL_CONFIGS[new_level]
	game_level = new_level

func on_lava_moved(lava_y):
	for platform in $Platforms.get_children():
		if platform.global_position.y > lava_y:
			platform.queue_free()

func _ready():
	EventBus.game_level_changed.connect(update_game_level)
	EventBus.lava_moved.connect(on_lava_moved)
	EventBus.highest_floor_changed.connect(on_highest_floor)
	spawn_platform(0, true)
	spawn_platforms(-100, - (GameManager.LEVEL_PIXELS_TRESHOLD * 2))

func on_highest_floor(highest_floor):
	var highest_floor_px = highest_floor * GameManager.LEVEL_PIXELS_TRESHOLD
	var next_level_close = is_next_level_close(highest_floor)
	
	if next_level_close:
		update_game_level(game_level + 1)
		
	var spawn_platforms_y_from = - (highest_floor_px + GameManager.LEVEL_PIXELS_TRESHOLD)
	var spawn_platforms_y_from_calculated = spawn_platforms_y_from - level_config['platform_spacing'] if next_level_close else spawn_platforms_y_from
	
	spawn_platforms(spawn_platforms_y_from_calculated, - (highest_floor_px + (GameManager.LEVEL_PIXELS_TRESHOLD * 2)))
	if next_level_close:
		spawn_platform((spawn_platforms_y_from_calculated + level_config['platform_spacing']) - 5, true)

func is_next_level_close(highest_floor):
	if (game_level == 5): return false
	var isClose = (GameManager.LEVEL_THRESHOLDS[game_level - 1] - 1) == highest_floor
	return isClose
