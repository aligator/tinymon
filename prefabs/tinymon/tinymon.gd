class_name Tinymon extends Node2D

@export var tinymon: Tinymon_data = Tinymon_data.new()

@onready var sprite: Sprite2D = $Sprite2D
@onready var label: Label = $Label

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#Global.new_data.connect(on_new_data)
	set_data(tinymon)
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func set_data(tinymon_data: Tinymon_data) -> void:
	self.tinymon = tinymon_data
	
	sprite.texture = ImageTexture.create_from_image(self.tinymon.image)
	self.tinymon
	
func on_new_data(tinymon: Tinymon_data):
	if tinymon.id != self.tinymon.id:
		return
	print("on_new_data", tinymon)
	set_data(tinymon)
