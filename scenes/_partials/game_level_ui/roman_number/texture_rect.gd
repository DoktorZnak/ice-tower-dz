extends TextureRect

func _ready() -> void:
	pivot_offset = Vector2(size.x / 2.0, 0.0)
	scale = Vector2(1.5, 1.5)
	modulate.a = 0.0
	position.y += 40.0
	
	var tween = create_tween()
	
	tween.tween_property(self, "position:y", position.y - 40.0, 0.3).set_trans(Tween.TRANS_CUBIC)
	tween.parallel().tween_property(self, "modulate:a", 1.0, 0.15)
	tween.tween_property(self, "scale", Vector2(1.0, 1.0), 0.4).set_trans(Tween.TRANS_ELASTIC)
