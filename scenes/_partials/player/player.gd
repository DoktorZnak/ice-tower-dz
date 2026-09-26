class_name Player extends CharacterBody2D

const MAX_SPEED = 200
const ACCELERATION = 200
const FRICTION = 20 # more = player stops/turns quicker
const BOUNCE_FORCE = 0.8

const BASE_JUMP_VELOCITY = -200
const MAX_JUMP_VELOCITY = -900

const COYOTE_DURATION = 0.1 # Czas na skok po spadnięciu (w sekundach)
const BUFFER_DURATION = 0.1 # Jak wcześnie przed ziemią można wcisnąć skok

var coyote_timer = 0.0
var jump_buffer_timer = 0.0

var calculated_acc = 1.5
var calculated_maxspeed = 2.5
var calculated_friction = 1
var jump_stat_modifier = 2
var jump_speed_bonus = 0.25
var jump_bounce_bonus = 0.25
var speed_before_collision = 0

var is_grounded = true

@onready var dust = preload("res://scenes/_partials/player/dust/dust.tscn")

var sounds = [
	preload("res://assets/sounds/jumping-sounds/jump1.mp3"),
	preload("res://assets/sounds/jumping-sounds/jump2.mp3"),
	preload("res://assets/sounds/jumping-sounds/jump3.mp3"),
	preload("res://assets/sounds/jumping-sounds/jump4.mp3"),
]

func play_jump_sound():
	if randf() >= 0.5:
		return
	var random_sound = sounds.pick_random()
	$AudioStreamPlayer2D.stream = random_sound
	$AudioStreamPlayer2D.play()

func is_player_grounded():
	return true if is_on_floor() or $PlatformCheckArea.has_overlapping_bodies() else false

func trigger_collapsing_platform():
	var collision = get_last_slide_collision()
	if collision != null:
		var collider = collision.get_collider()
		if collider != null and collider.has_method("collapse"):
			collider.collapse()

func update_players_stats():
	calculated_acc = ACCELERATION * remap(GameManager.players_stats.acc.value, 1, GameManager.PLAYERS_STATS_MAX['acc'], 1.5, 8)
	calculated_maxspeed = MAX_SPEED * remap(GameManager.players_stats.maxspeed.value, 1, GameManager.PLAYERS_STATS_MAX['maxspeed'], 2.5, 8)
	calculated_friction = FRICTION * remap(GameManager.players_stats.friction.value, 1, GameManager.PLAYERS_STATS_MAX['friction'], 1, 80)
	jump_stat_modifier = remap(GameManager.players_stats.jump.value, 1, GameManager.PLAYERS_STATS_MAX['jump'], 2, 4)
	
	var average_stat = (GameManager.players_stats.maxspeed.value + GameManager.players_stats.jump.value + GameManager.players_stats.acc.value) / 3.0
	jump_speed_bonus = remap(average_stat, 1, 400, 0.25, 0.4)
	jump_bounce_bonus = remap(average_stat, 1, 400, 0.25, 0.35)

func handle_direction(delta):
	var direction := Input.get_axis("left", "right")
	var to = direction * calculated_maxspeed
	var delta_calc = calculated_acc * delta
	
	if direction == 0.0:
		delta_calc = calculated_friction * delta
	elif sign(velocity.x) != sign(direction) and velocity.x != 0.0:
		delta_calc = (calculated_friction + (calculated_acc * 0.2)) * delta
	velocity.x = move_toward(velocity.x, to, delta_calc)

func handle_jump(delta):
	jump_buffer_timer = BUFFER_DURATION if Input.is_action_just_pressed("jump") else jump_buffer_timer - delta
	if jump_buffer_timer > 0.0 and coyote_timer > 0.0:
		jump_buffer_timer = 0.0
		coyote_timer = 0.0
		trigger_collapsing_platform()
		var mod_base_jump = BASE_JUMP_VELOCITY * jump_stat_modifier
		var mod_max_jump = MAX_JUMP_VELOCITY * jump_stat_modifier
		var horizontal_momentum = abs(velocity.x)
		var extra_jump_force = horizontal_momentum * jump_speed_bonus
		var calculated_jump = mod_base_jump - extra_jump_force
		velocity.y = clamp(calculated_jump, mod_max_jump, mod_base_jump)
		play_jump_sound()
	
func handle_wall_bounce():
	var actual_impact_speed = abs(speed_before_collision)
	var minimum_impact_speed = 400.0
	if actual_impact_speed >= minimum_impact_speed:
		if not $BounceAudio.playing:
			$BounceAudio.play()
	var wall_normal = get_wall_normal().x
	velocity.x = wall_normal * actual_impact_speed * 0.4
	if not is_on_floor():
		velocity.y -= actual_impact_speed * jump_bounce_bonus

func perform_move():
	speed_before_collision = velocity.x
	move_and_slide()

func play_animations():
	if is_grounded == false and is_on_floor() == true:
		var instance = dust.instantiate()
		instance.global_position = $Marker2D.global_position
		get_parent().add_child(instance)
	
	is_grounded = is_on_floor()
	
	var direction := Input.get_axis("left", "right")
	
	if direction == 0.0:
		$AnimatedSprite2D.play("idle" if is_player_grounded() else "jump_idle")
	else:
		$AnimatedSprite2D.play("run" if is_player_grounded() else "jump_direction")
		$AnimatedSprite2D.flip_h = direction < 0

func update_camera(y):
	var target_limit = y + 64
	$Camera2D.limit_bottom = target_limit

func on_game_level_change(game_level):
	if game_level == 1: return
	
	var current_floor = GameManager.LEVEL_THRESHOLDS[game_level - 2]
	var y_px = - (current_floor * GameManager.LEVEL_PIXELS_TRESHOLD) + 50
	var target_limit = y_px + 64
	
	var tween = create_tween()
	tween.tween_property($Camera2D, "limit_bottom", target_limit, 0.5) \
		.set_trans(Tween.TRANS_CUBIC) \
		.set_ease(Tween.EASE_OUT)

func _ready():
	update_players_stats()
	EventBus.lava_moved.connect(update_camera)
	EventBus.stats_updated.connect(update_players_stats)
	EventBus.game_level_changed.connect(on_game_level_change)
