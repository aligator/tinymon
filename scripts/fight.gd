class_name Fight extends CanvasLayer

var tinymon1: Tinymon_data
var tinymon2: Tinymon_data


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

	
func _on_pressed(type: Global.FIGHT_TYPE) -> void:
	if Global.fight(tinymon1, type, tinymon2) == Global.WINNING_TYPE.DRAW:
		return
	
	visible = false
	Global.fight_done(tinymon2)


func _on_paper_pressed() -> void:
	_on_pressed(Global.FIGHT_TYPE.PAPER)


func _on_stone_pressed() -> void:
	_on_pressed(Global.FIGHT_TYPE.STONE)


func _on_scissors_pressed() -> void:
	_on_pressed(Global.FIGHT_TYPE.SCISSOR)
