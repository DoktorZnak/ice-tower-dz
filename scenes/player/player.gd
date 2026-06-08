extends CharacterBody2D

const MAX_SPEED = 200
const JUMP_VELOCITY = -400
const ACCELERATION = 200
const FRICTION = 20 # more = player stops/turns quicker
const BOUNCE_FORCE = 0.8

const BASE_JUMP_VELOCITY = -300
const MAX_JUMP_VELOCITY = -900
const JUMP_SPEED_BONUS = 0.6

const COYOTE_DURATION = 0.1 # Czas na skok po spadnięciu (w sekundach)
const BUFFER_DURATION = 0.1 # Jak wcześnie przed ziemią można wcisnąć skok

var coyote_timer = 0.0
var jump_buffer_timer = 0.0


func is_player_grounded():
	return true if is_on_floor() or $PlatformCheckArea.has_overlapping_bodies() else false

func trigger_collapsing_platform():
	var collision = get_last_slide_collision()
	if collision != null:
		var collider = collision.get_collider()
		if collider != null and collider.has_method("collapse"):
			collider.collapse()

func handle_direction(delta: float) -> void:
	var calculated_acc = ACCELERATION * remap(GameManager.players_stats.acc.value, 1.0, 100.0, 1.0, 2.5)
	var calculated_maxspeed = MAX_SPEED * remap(GameManager.players_stats.maxspeed.value, 1.0, 100.0, 1.0, 4)
	var calculated_friction = FRICTION * remap(GameManager.players_stats.friction.value, 1.0, 100.0, 1.0, 14)
	
	var direction := Input.get_axis("left", "right")
	
	var to = direction * calculated_maxspeed
	var delta_calc = calculated_acc * delta
	
	if direction == 0.0:
		delta_calc = calculated_friction * delta
	elif sign(velocity.x) != sign(direction) and velocity.x != 0.0:
		delta_calc = (calculated_friction + (calculated_acc * 0.2)) * delta
		
	velocity.x = move_toward(velocity.x, to, delta_calc)

	
func _physics_process(delta: float):
	if is_player_grounded():
		coyote_timer = COYOTE_DURATION # Resetuj czas kojota, gdy stoisz na ziemi
		trigger_collapsing_platform()
	else:
		coyote_timer -= delta # Odliczaj, gdy jesteś w powietrzu
		velocity += get_gravity() * delta
		
	jump_buffer_timer = BUFFER_DURATION if Input.is_action_just_pressed("jump") else jump_buffer_timer - delta

	if jump_buffer_timer > 0.0 and coyote_timer > 0.0:
		jump_buffer_timer = 0.0
		coyote_timer = 0.0
		trigger_collapsing_platform()
		
		var horizontal_momentum = abs(velocity.x)
		var extra_jump_force = horizontal_momentum * JUMP_SPEED_BONUS
		
		var calculated_jump = BASE_JUMP_VELOCITY - extra_jump_force
		velocity.y = clamp(calculated_jump, MAX_JUMP_VELOCITY, BASE_JUMP_VELOCITY)
	
	handle_direction(delta)
	
	var speed_before_collision = velocity.x
	move_and_slide()

	if is_on_wall():
		var actual_impact_speed = abs(speed_before_collision)
		var wall_normal = get_wall_normal().x
		velocity.x = wall_normal * actual_impact_speed * 0.4

		if not is_on_floor():
			velocity.y -= actual_impact_speed * 0.5
