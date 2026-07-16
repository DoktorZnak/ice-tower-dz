extends Control

@export_enum("tax","acc","maxspeed","jump","friction") var tome_type = 'tax' 
@export_enum("common", "uncommon", "rare") var tome_rarity: String = "common"

signal card_clicked

var rarity_color = {
	'common': '#FFFFFF',
	'uncommon': '#1EFF00',
	'rare': '#0070DD'
}

var new_value = 0

var upgrade_card_hover_style
var upgrade_card_style

func setup_tome_ui():
	%StatsContainer.visible = true
	%RarityLabel.set("theme_override_colors/font_color", rarity_color[tome_rarity])
	%RarityLabel.set("text", tome_rarity.to_pascal_case())
	setupPanelTextureRect()
	var texture_path = "res://assets/tomes/" + tome_type + "-tome.png" 
	%TextureRect.set('texture', load(texture_path)) 
	
	if tome_type == 'tax': 
		%TomeNameLabel.set('text', "Tax Tome")
		%StatsContainer.set('visible', false)
		return

	var player_stat = GameManager.players_stats[tome_type] 
	var current_value = player_stat.value 
	new_value = current_value + get_random_bonus_by_rarity()
	
	%TomeNameLabel.set('text', player_stat.label + " Tome")
	%CurrentStateLabel.set('text', player_stat.label + " " + str(current_value) + "%")
	%NewStateLabel.set('text', str(new_value) + "%")

func setupPanelTextureRect():
	var original_style = %PanelTextureRect.get("theme_override_styles/panel")
	var unique_style = original_style.duplicate()
	unique_style.border_color = Color(rarity_color[tome_rarity], 1)
	%PanelTextureRect.add_theme_stylebox_override("panel", unique_style)

func get_random_bonus_by_rarity():
	match tome_rarity:
		"common":   return randi_range(10, 20)
		"uncommon": return randi_range(21, 41)
		"rare":     return randi_range(42, 60)
	return 0


func setup(): # needs to be executed from parent node
	setup_tome_ui()

func _ready():
	upgrade_card_style = $".".get_theme_stylebox("panel")
	upgrade_card_hover_style = upgrade_card_style.duplicate()
	upgrade_card_hover_style.border_color = Color('#FFFFFF')

func _on_mouse_entered():
	$".".add_theme_stylebox_override("panel", upgrade_card_hover_style)

func _on_mouse_exited():
	$".".add_theme_stylebox_override("panel", upgrade_card_style)

func _on_gui_input(event: InputEvent):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			if(tome_type != 'tax'):
				GameManager.set_stat_point(tome_type, new_value)
			card_clicked.emit()
			get_tree().paused = false
