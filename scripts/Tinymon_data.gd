@icon("res:///assets/img/tinymon.png")

# (optional) class definition:
class_name Tinymon_data extends Node

enum ELEMENT_TYPE {FIRE, WATER, AIR}

# Member variables.
@export var id: String
@export var tinymon_name: String
@export var image: Image
@export var level: int
@export var progress: int
@export var element_type: ELEMENT_TYPE

# Constructor
func _init(
	id: String = "",
	name: String = "", 
	image: Image = Image.new(), 
	level: int = 1, 
	progress: int = 100, 
	element_type: ELEMENT_TYPE = ELEMENT_TYPE.FIRE
):
	self.id = id
	
	self.tinymon_name = name
	self.image = image
	
	self.level = level
	self.progress = progress
	
	self.element_type = element_type
