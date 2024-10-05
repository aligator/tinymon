@icon("res:///assets/img/tinymon.png")

# (optional) class definition:
class_name Tinymon_data extends Node

# Member variables.
@export var tinymon_name: String
@export var image: Image

# Constructor
func _init(name: String = "", image: Image = Image.new()):
	self.tinymon_name = name
	self.image = image
