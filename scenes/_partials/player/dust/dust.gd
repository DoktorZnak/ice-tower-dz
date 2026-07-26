extends AnimatedSprite2D

var animation_done = false
var audio_done = false

var landing = [
	preload("res://assets/sounds/Landing Sound Effects.mp3"),
	preload("res://assets/sounds/footstep.mp3"),
]

func _ready():
	$AudioStreamPlayer2D.finished.connect(_on_audio_finished)

func _on_animation_finished():
	animation_done = true
	check_and_free()

func _on_audio_finished():
	audio_done = true
	check_and_free()

func check_and_free():
	if animation_done and audio_done:
		queue_free()
