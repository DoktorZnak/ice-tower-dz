extends CanvasLayer

var types: Array[String] = ["tax", "acc", "maxspeed", "jump", "friction"]
var rarities: Array[String] = ["common", "uncommon", "rare"]

@onready var cards: Array[Control] = [
	$PanelContainer3/MarginContainer/VBoxContainer/UpgradeCard1,
	$PanelContainer3/MarginContainer/VBoxContainer/UpgradeCard2,
	$PanelContainer3/MarginContainer/VBoxContainer/UpgradeCard3
]

func open_upgrade_menu():
	for card in cards:
		card.tome_type = types.pick_random()
		card.tome_rarity = rarities.pick_random()
		card.setup()
	
	show()
	
	get_tree().paused = true

func _ready():
	randomize()
	
func _process(_delta):
	if Input.is_action_just_pressed('unpause'):
		hide()
		get_tree().paused = false
