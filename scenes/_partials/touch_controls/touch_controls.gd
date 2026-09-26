extends CanvasLayer

# On-screen buttons for mobile browsers. Only visible on touchscreen devices.

const BUTTON_SIZE = 150
const MARGIN = 30
const GAP = 20

func make_button(action: String, text: String, pos: Vector2):
	var img = Image.create(BUTTON_SIZE, BUTTON_SIZE, false, Image.FORMAT_RGBA8)
	img.fill(Color(1, 1, 1, 0.25))
	var pressed_img = Image.create(BUTTON_SIZE, BUTTON_SIZE, false, Image.FORMAT_RGBA8)
	pressed_img.fill(Color(1, 1, 1, 0.5))

	var shape = RectangleShape2D.new()
	shape.size = Vector2(BUTTON_SIZE, BUTTON_SIZE)

	var button = TouchScreenButton.new()
	button.texture_normal = ImageTexture.create_from_image(img)
	button.texture_pressed = ImageTexture.create_from_image(pressed_img)
	button.shape = shape
	button.shape_centered = true
	button.action = action
	button.passby_press = true # sliding a finger between left/right switches direction
	button.position = pos

	var label = Label.new()
	label.text = text
	label.size = Vector2(BUTTON_SIZE, BUTTON_SIZE)
	label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	label.add_theme_font_size_override("font_size", 48)
	button.add_child(label)

	add_child(button)

func _process(_delta):
	visible = GameManager.touch_used

func _ready():
	visible = GameManager.touch_used
	var screen = get_viewport().get_visible_rect().size
	var y = screen.y - BUTTON_SIZE - MARGIN
	make_button("left", "<", Vector2(MARGIN, y))
	make_button("right", ">", Vector2(MARGIN + BUTTON_SIZE + GAP, y))
	make_button("jump", "^", Vector2(screen.x - BUTTON_SIZE - MARGIN, y))
