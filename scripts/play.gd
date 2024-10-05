extends Button

@onready
var nameEdit: LineEdit = %NameEdit
@onready
var canvas: TextureRect = %Canvas

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	disabled = !nameEdit.text
	
func _on_pressed() -> void:
	await Global.new_tinymon(Tinymon_data.new(nameEdit.text, canvas.texture.get_image()))
	get_tree().change_scene_to_file("res://views/game.tscn")
