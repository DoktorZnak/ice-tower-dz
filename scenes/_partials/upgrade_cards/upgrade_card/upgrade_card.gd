extends Control

var players_stats = { 
	'acc': {'value': 100, 'label': 'Acceleration'}, 
	'maxspeed': {'value': 100, 'label': 'Speed'}, 
	'jump': {'value': 100, 'label': 'Jump'}, 
	'friction': {'value': 100, 'label': 'Friction'}, 
} 

@export_enum("tax","acc","maxspeed","jump","friction") var tome_type = 'tax' 
@export_enum("common", "rare", "epic") var tome_rarity: String = "common"

var new_value = 0

func get_random_bonus_by_rarity() -> int:
	var min_bonus = 0
	var max_bonus = 0
	
	match tome_rarity:
		"common":
			min_bonus = 5
			max_bonus = 15
		"rare":
			min_bonus = 16
			max_bonus = 30
		"epic":
			min_bonus = 31
			max_bonus = 50
			
	return randi_range(min_bonus, max_bonus)


func _ready() -> void: 
	var texture_path = "res://assets/tomes/" + tome_type + "-tome.png" 
	$PanelContainer2/TomeSprite.texture = load(texture_path) 
	$Title.text = tome_type.to_pascal_case() + " Tome" 
	
	if tome_type != 'tax': 
		var player_stat = GameManager.players_stats[tome_type] 
		var current_value = player_stat.value 
		
		var bonus = get_random_bonus_by_rarity()
		
		new_value = current_value + bonus
		
		$HBoxContainer/StateLabel.text = player_stat.label + " " + str(current_value) + "% -> "
		$HBoxContainer/NewValueLabel.text = str(new_value) + "%" 
	else: 
		$HBoxContainer.visible = false 
