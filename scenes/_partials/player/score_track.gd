extends Node

var p: Player

var highest_score: int = 0
const PIXELS_PER_FLOOR: float = 150.0

func _ready():
	await owner.ready
	p = owner as Player

func _physics_process(_delta):
	var current_floor = int(abs(p.global_position.y) / PIXELS_PER_FLOOR)
	if current_floor > highest_score:
		highest_score = current_floor
		EventBus.highest_score_changed.emit(highest_score) 
