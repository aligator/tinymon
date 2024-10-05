# this script is based on:
# 	https://codeberg.org/sossees/simplest-paint-in-godot-4
# licensed with MIT License:
# 	https://codeberg.org/sosasees/mit-license/raw/branch/2021/LICENSE
extends TextureRect


@export var picture_size : Vector2i = Vector2i(512, 512)
@export var padding : int = 0
@export var brush_radius : Vector2i = Vector2i(4, 4)
@export var line_tween_points : int = 128
@export var brush_color : Color = Color('000000')

var canvas_image : Image
var canvas_texture : ImageTexture
var brush_image : Image

var update_canvas : Callable = func() -> void:
	canvas_texture = ImageTexture.create_from_image(canvas_image)
	texture = canvas_texture

var line : PackedVector2Array

var draw_dot : Callable = func(new_position:Vector2i) -> void:
	canvas_image.fill_rect(
		Rect2i(new_position - brush_radius, brush_radius*2),
		brush_color
	)
	
func render_line(new_line : PackedVector2Array) -> void:
	for i in line_tween_points: # could be changed to a parallel for loop
		draw_dot.call(
			lerp( new_line[-1], new_line[-2], float(i+1)/(line_tween_points+1) )
		)


func _ready() -> void:
	canvas_image = Image.create(
		picture_size.x + padding*2, picture_size.y + padding*2,
		false, Image.FORMAT_RGBA8
	)
	update_canvas.call()


func _gui_input(event) -> void:
	if (event is InputEventMouse and event.get_button_mask() == 1) \
			or event is InputEventScreenDrag:
		var pos = get_local_mouse_position() - (size - Vector2(picture_size)) / 2 + Vector2(padding, padding)
		line.append(pos)
		if line.size() > 0:
			draw_dot.call(line[-1])
			if line.size() > 1:
				render_line(line)
		update_canvas.call()
	else:
		line.clear()


func _on_color_picker_button_color_changed(color: Color) -> void:
	brush_color = color
