class_name Platform extends TileMapLayer

@export var length: int = 1
@export var count: int = 1
@export var can_collapse = true

var main: MainScript

const LEVEL_CONFIGS = {
	1: { 'fall_delay': 2000, 'fall_y_offset': 500, 'fall_duration': 10 },
	2: { 'fall_delay': 1500, 'fall_y_offset': 500, 'fall_duration': 9 },
	3: { 'fall_delay': 1000, 'fall_y_offset': 450, 'fall_duration': 7 },
	4: { 'fall_delay': 500, 'fall_y_offset': 400, 'fall_duration': 5 },
	5: { 'fall_delay': 300, 'fall_y_offset': 350, 'fall_duration': 3 }
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
		fall_with_delay(LEVEL_CONFIGS[main.current_game_level]['fall_delay'])

func fall_with_delay(delay_ms):
	var tween = create_tween()
	if delay_ms > 0:
		tween.tween_interval(delay_ms / 1000.0)
	tween.finished.connect(start_falling)

func start_falling():
	var fall_y_offset = LEVEL_CONFIGS[main.current_game_level]['fall_y_offset']
	var fall_duration = LEVEL_CONFIGS[main.current_game_level]['fall_duration']
	var tween = create_tween().set_parallel(true).set_process_mode(Tween.TWEEN_PROCESS_PHYSICS)
	tween.tween_property(self, "position:y", position.y + fall_y_offset, fall_duration).set_trans(Tween.TRANS_LINEAR).set_ease(Tween.EASE_IN_OUT)
	tween.tween_property(self, "modulate:a", 0.0, 1.0).set_delay(fall_duration -1).set_trans(Tween.TRANS_LINEAR)
	tween.chain().tween_callback(queue_free)

func _ready():
	draw_platform()
	draw_label()
