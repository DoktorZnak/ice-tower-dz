extends Node2D

var platform_scene: PackedScene = preload("res://scenes/_partials/platform_builder/platform/platform.tscn")
@onready var main := get_owner() as MainScript

var platform_counter = 1
var next_spawn_y = 0

const LEVEL_CONFIGS = {
	1: {'center_offset': 350, 'platform_spacing': 120},
	2: {'center_offset': 398, 'platform_spacing': 140},
	3: {'center_offset': 446, 'platform_spacing': 160},
	4: {'center_offset': 494, 'platform_spacing': 180},
	5: {'center_offset': 542, 'platform_spacing': 200}
}

var level_config = LEVEL_CONFIGS[1]
var game_level = 1

func spawn_next_platform(custom_length = null):
	platform_counter += 1
	var new_platform = platform_scene.instantiate() as Platform
	new_platform.count = platform_counter
	new_platform.length = custom_length if custom_length else randi_range(11, 14)
	new_platform.game_level = game_level
	
	var platform_half_length = (new_platform.length * 22 / 2)

	var center_offset = level_config['center_offset']
	var platform_spacing = level_config['platform_spacing']

	var random_x = randf_range(-center_offset + platform_half_length, center_offset - platform_half_length)
	new_platform.global_position = Vector2(random_x, next_spawn_y)
	$Platforms.add_child(new_platform)
	next_spawn_y -= platform_spacing

func update_game_level(new_level):
	level_config = LEVEL_CONFIGS[new_level]
	game_level = new_level

func _ready():
	EventBus.game_level_changed.connect(update_game_level)
	spawn_next_platform(50)
	for y in range(1, 4):
		spawn_next_platform()
	spawn_next_platform()
	$Area2D.global_position.y = -200

func _on_area_2d_body_entered(_body):
	$Area2D.global_position.y -= 600
	for y in range(1, 6):
		spawn_next_platform()

#func clean_old_platforms(cleanup_y):
	#for platform in $Platforms.get_children():
		#if platform.is_falling:
			#continue
			#
		#if platform.global_position.y > cleanup_y:
			#if platform.has_method("collapse"):
				#platform.force_collapse()
