extends TileMapLayer

@export var length: int = 1
@export var count: int = 1
@export var can_collapse = true

const LEFT_EDGE = Vector2i(1, 0)
const MIDDLE_PIECE = Vector2i(2, 0)
const RIGHT_EDGE = Vector2i(3, 0)

var is_falling = false

func _ready():
	draw_platform()
	draw_label()

func draw_platform():
	clear()
	
	var half_len = length / 2
	
	set_cell(Vector2i(-half_len - 1, 0), 0, LEFT_EDGE)
	for i in range(length):
		set_cell(Vector2i(-half_len + i, 0), 0, MIDDLE_PIECE)
	set_cell(Vector2i(-half_len + length, 0), 0, RIGHT_EDGE)

func draw_label():
	$Label.text = str(count)
	$Label.visible = true if count % 10 == 0 else false

func collapse():
	if !is_falling && can_collapse:
		is_falling = true
		shake_platform(1000, 1000)

func force_collapse():
	if !is_falling:
		is_falling = true
		shake_platform(1000, 1000)

func shake_platform(duration_ms: float, delay_ms: float) -> void:
	var tween = create_tween()
	
	if delay_ms > 0:
		tween.tween_interval(delay_ms / 1000.0)
		
	var total_duration_seconds = duration_ms / 1000.0
	var steps = 8
	var step_speed = total_duration_seconds / (steps + 1)
	var max_shake_angle = deg_to_rad(3.0)
	
	for i in range(steps):
		var factor = 1.0 - (float(i) / steps)
		var direction = 1.0 if i % 2 == 0 else -1.0
		var current_angle = max_shake_angle * factor * direction
		
		tween.tween_property(self , "rotation", current_angle, step_speed) \
			.set_trans(Tween.TRANS_SINE) \
			.set_ease(Tween.EASE_IN_OUT)
		
	tween.tween_property(self , "rotation", 0.0, step_speed) \
		.set_trans(Tween.TRANS_SINE) \
		.set_ease(Tween.EASE_IN_OUT)
		
	tween.finished.connect(start_falling)


func start_falling():
	var tween = create_tween().set_parallel(true)
	tween.tween_property(self , "position:y", position.y + 300, 0.8).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN)
	tween.tween_property(self , "modulate:a", 0.0, 0.8)
	tween.chain().tween_callback(queue_free)
