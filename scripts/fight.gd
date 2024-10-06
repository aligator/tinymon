class_name Fight extends CanvasLayer

var fight_stats: Fight_stats
var tinymon1: Tinymon_data
var tinymon2: Tinymon_data


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

	
func _on_pressed(type: Global.FIGHT_TYPE) -> void:
	if await Global.fight(tinymon1, type, fight_stats) == Global.WINNING_TYPE.DRAW:
		return
	
	visible = false
	Global.fight_done(tinymon2)

func _on_tackle_pressed() -> void:
	_on_pressed(Global.FIGHT_TYPE.TACKLE)


func _on_firestorm_pressed() -> void:
	_on_pressed(Global.FIGHT_TYPE.FIRESTORM)


func _on_fireball_pressed() -> void:
	_on_pressed(Global.FIGHT_TYPE.FIREBALL)


func _on_flood_pressed() -> void:
	_on_pressed(Global.FIGHT_TYPE.FLOOD)


func _on_splash_pressed() -> void:
	_on_pressed(Global.FIGHT_TYPE.SPLASH)


func _on_earthquake_pressed() -> void:
	_on_pressed(Global.FIGHT_TYPE.EARTHQUAKE)


func _on_meteor_pressed() -> void:
	_on_pressed(Global.FIGHT_TYPE.METEOR)
