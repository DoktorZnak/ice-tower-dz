extends HBoxContainer

@export_enum('acc', 'maxspeed', 'jump', 'friction', 'xp') var stat_type = 'acc'

func _ready():
	var player_stat = GameManager.players_stats[stat_type]
	
	$ProgressBar.min_value = player_stat.value
	$ProgressBar.max_value = 200
	$StatLabel.text = player_stat.label
