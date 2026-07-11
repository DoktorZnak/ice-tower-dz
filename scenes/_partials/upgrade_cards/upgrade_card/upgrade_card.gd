extends Control

@export_enum("tax","acc","maxspeed","jump","friction") var tome_type = 'tax' 
@export_enum("common", "uncommon", "rare") var tome_rarity: String = "common"

# Unused local players_stats dictionary was removed to save memory

var rarity_color = {
	'common': '#FFFFFF',
	'uncommon': '#1EFF00',
	'rare': '#0070DD'
}

var new_value = 0

# Visual Anchors: Fetching nodes once at the start is faster and safer
@onready var rarity_label = %RarityLabel
@onready var texture_rect = %TextureRect
@onready var tome_name_label = %TomeNameLabel
@onready var stats_hbox = %HBoxContainer
@onready var current_state_label = %CurrentStateLabel
@onready var new_state_label = %NewStateLabel

func _ready() -> void: 
	setup_tome_ui()

func setup_tome_ui() -> void:
	# 1. Update Rarity UI
	rarity_label.set("theme_override_colors/font_color", rarity_color[tome_rarity])
	rarity_label.set("text", tome_rarity.to_pascal_case())
	
	# 2. Update Texture
	var texture_path = "res://assets/tomes/" + tome_type + "-tome.png" 
	texture_rect.set('texture', load(texture_path)) 
	
	# 3. Handle 'Tax' Type
	if tome_type == 'tax': 
		tome_name_label.set('text', "Tax Tome")
		stats_hbox.set('visible', false)
		return # Exit early so we don't need a massive 'else' block

	# 4. Handle Stat Types
	var player_stat = GameManager.players_stats[tome_type] 
	var current_value = player_stat.value 
	new_value = current_value + get_random_bonus_by_rarity()
	
	tome_name_label.set('text', player_stat.label + " Tome")
	current_state_label.set('text', player_stat.label + " " + str(current_value) + "% -> ")
	new_state_label.set('text', str(new_value) + "%")

func get_random_bonus_by_rarity() -> int:
	match tome_rarity:
		"common":   return randi_range(5, 15)
		"uncommon": return randi_range(16, 30)
		"rare":     return randi_range(31, 50)
	return 0
