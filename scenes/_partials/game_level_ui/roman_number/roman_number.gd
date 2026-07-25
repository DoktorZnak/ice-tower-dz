extends Control

@export_enum('1','5') var number = '1' 

func _ready():
	var path = 'res://assets/numbers/Number' + number + '.png'
	$TextureRect.texture = load(path)
