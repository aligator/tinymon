extends ColorPickerButton


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	color = Color(Global.rng.randf(), Global.rng.randf(), Global.rng.randf())
	%Canvas.brush_color = color
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_color_changed(color: Color) -> void:
	var img = Image.new()
	img.fill(color)
	set_button_icon(ImageTexture.create_from_image(img))
