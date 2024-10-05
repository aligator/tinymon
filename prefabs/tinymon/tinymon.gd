class_name Tinymon extends Node2D

@export var tinymon: Tinymon_data = Tinymon_data.new()

@onready var sprite: Sprite2D = $Sprite2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	set_data(tinymon)
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func set_data(tinymon_data: Tinymon_data) -> void:
	print("changed")
	print(sprite.texture)

	self.tinymon = tinymon_data
	
	print(sprite.texture)
	print(self.tinymon.image.get_size())
	sprite.texture = ImageTexture.create_from_image(self.tinymon.image)
	print(sprite.texture)
