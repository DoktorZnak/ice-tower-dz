class_name Platform extends TileMapLayer

@export var length: int = 1
@export var count: int = 1
@export var can_collapse = true

var level_config: Dictionary

var game_level:
	set(value):
		level_config = LEVEL_CONFIGS[value]

const LEVEL_CONFIGS = {
	1: {
		'fall_delay': 3000, 'fall_y_offset': 500, 'fall_duration': 8,
		'colors': {'light_gray': "878156", 'dark_blue': "1b240f", 'med_gray': "2e421d", 'new_blue': "304016", 'mid_blue': "458032", 'light_blue': "d8de6a"}
	},
	2: {
		'fall_delay': 2000, 'fall_y_offset': 500, 'fall_duration': 7,
		'colors': {'light_gray': "adb1c9", 'dark_blue': "212435", 'med_gray': "727590", 'new_blue': "393e5b", 'mid_blue': "575b75", 'light_blue': "7d84aa"}
	},
	3: {
		'fall_delay': 1000, 'fall_y_offset': 450, 'fall_duration': 6,
		'colors': {'light_gray': "f5b041", 'dark_blue': "2c1a1a", 'med_gray': "cb4335", 'new_blue': "e67e22", 'mid_blue': "40752e", 'light_blue': "38ab4d"}
	},
	4: {
		'fall_delay': 500, 'fall_y_offset': 400, 'fall_duration': 5,
		'colors': {'light_gray': "adb1c9", 'dark_blue': "212435", 'med_gray': "727590", 'new_blue': "393e5b", 'mid_blue': "40752e", 'light_blue': "38ab4d"}
	},
	5: {
		'fall_delay': 300, 'fall_y_offset': 350, 'fall_duration': 3,
		'colors': {'light_gray': "5b2c6f", 'dark_blue': "110515", 'med_gray': "4a235a", 'new_blue': "2e4053", 'mid_blue': "40752e", 'light_blue': "38ab4d"}
	}
}

var is_falling = false
var target_y: float = 0.0
var fall_speed: float = 0.0

const LEFT_EDGE = Vector2i(0, 0)
const MIDDLE_PIECE = Vector2i(1, 0)
const RIGHT_EDGE = Vector2i(2, 0)

func draw_platform():
	clear()
	
	var half_len = length / 2
	
	set_cell(Vector2i(-half_len - 1, 0), 1, LEFT_EDGE)
	for i in range(length):
		set_cell(Vector2i(-half_len + i, 0), 1, MIDDLE_PIECE)
	set_cell(Vector2i(-half_len + length, 0), 1, RIGHT_EDGE)
	
	var TILE_SIZE = 16
	var total_width = (length + 2) * TILE_SIZE

func draw_label():
	$Label.text = str(count)
	$Label.visible = true if count % 10 == 0 else false

func collapse():
	if !is_falling && can_collapse:
		is_falling = true
		fall_with_delay(level_config['fall_delay'])

func fall_with_delay(delay_ms):
	var tween = create_tween()
	if delay_ms > 0:
		tween.tween_interval(delay_ms / 1000.0)
	tween.finished.connect(start_falling)

func start_falling():
	var fall_duration = level_config['fall_duration']
	var tween = create_tween().set_parallel(true).set_process_mode(Tween.TWEEN_PROCESS_PHYSICS)
	tween.tween_property(self, "position:y", position.y + level_config['fall_y_offset'], fall_duration).set_trans(Tween.TRANS_LINEAR).set_ease(Tween.EASE_IN_OUT)
	tween.tween_property(self, "modulate:a", 0.0, 1.0).set_delay(fall_duration - 1).set_trans(Tween.TRANS_LINEAR)
	tween.chain().tween_callback(queue_free)

func apply_level_shader_colors():
	var mat = material as ShaderMaterial
	if not mat or not level_config.has('colors'): return
	
	var colors = level_config['colors']
	mat.set_shader_parameter("target_light_gray", Color(colors['light_gray']))
	mat.set_shader_parameter("target_dark_blue", Color(colors['dark_blue']))
	mat.set_shader_parameter("target_med_gray", Color(colors['med_gray']))
	mat.set_shader_parameter("target_new_blue", Color(colors['new_blue']))
	mat.set_shader_parameter("target_mid_blue", Color(colors['mid_blue']))
	mat.set_shader_parameter("target_light_blue", Color(colors['light_blue']))

func _ready():
	if material:
		material = material.duplicate()
	
	apply_level_shader_colors()
	
	draw_platform()
	draw_label()
