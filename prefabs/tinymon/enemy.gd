class_name Enemy extends Area2D

@onready var tinymon: Tinymon = %Tinymon

signal start_fight

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func set_tinymon(tinymon: Tinymon_data):
	self.tinymon.set_data(tinymon)
	
func _on_body_entered(body: Node2D) -> void:
	start_fight.emit(self)
