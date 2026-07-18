extends Node

var p: Player


func _ready():
	await owner.ready
	p = owner as Player

func _physics_process(delta):
	if p.is_on_floor():
		p.velocity.y = 100
	if p.is_player_grounded():
		p.coyote_timer = p.COYOTE_DURATION
		p.trigger_collapsing_platform()
	else:
		p.coyote_timer -= delta
		p.velocity += p.get_gravity() * delta
	
	p.handle_jump(delta)
	p.handle_direction(delta)
	p.perform_move()
	p.play_animations()
	if p.is_on_wall():
		p.handle_wall_bounce()
