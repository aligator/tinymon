extends Button

@onready
var nameEdit: LineEdit = %NameEdit

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	Global.tinymon_name = nameEdit.name
	#get_tree().change_scene("res://path/to/scene.tscn")
	pass
