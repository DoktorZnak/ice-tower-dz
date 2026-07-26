extends Area2D

var MIN_BOTTOM = 500

func _on_point_above_player_area_body_entered(_body):
	$PointAbovePlayerArea.global_position.y -= 600
	var new_position = min($PointAbovePlayerArea.global_position.y + 1200, MIN_BOTTOM)
	
	$".".global_position.y = new_position
	EventBus.lava_moved.emit(new_position)

func _on_death_area_body_entered(_body):
	print('game over!')
	

func _ready():
	$PointAbovePlayerArea.global_position.y = -800
