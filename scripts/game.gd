extends Node2D

@export 
var tinymon_data: Tinymon_data = Tinymon_data.new()

@onready
var tinymon: Tinymon = %Tinymon

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	tinymon.set_data(Global.tinymon)
	tinymon.position = get_viewport_rect().size / 2

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
