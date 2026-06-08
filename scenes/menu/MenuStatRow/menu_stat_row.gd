extends HBoxContainer

@export var stat_name: String = 'acc'

func _ready() -> void:
	update_ui()

func update_ui() -> void:
	$StatNameLabel.text = str(GameManager.players_stats[stat_name].label)
	$ValueLabel.text = str(GameManager.players_stats[stat_name].value)
	
	if GameManager.stat_points == 0 or GameManager.players_stats[stat_name].value == 100:
		$VBoxContainer/PlusButton.hide()

func _on_plus_button_pressed() -> void:
	GameManager.add_stat_point(stat_name)
	update_ui()
