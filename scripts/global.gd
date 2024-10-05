extends Node

var tinymon: Tinymon_data = Tinymon_data.new()

func new_enemy() -> Tinymon_data:
	return Tinymon_data.new("enemy", Image.load_from_file("res://assets/img/tinymon.png"))
