extends Node

var rng = RandomNumberGenerator.new()

var tinymon: Tinymon_data = Tinymon_data.new()

enum FIGHT_TYPE {SCISSOR, STONE, PAPER}
enum WINNING_TYPE {LOOSER, DRAW, WINNER}

signal new_data
signal remove_enemy

func new_enemy() -> Tinymon_data:
	return Tinymon_data.new("enemy", Image.load_from_file("res://assets/img/tinymon.png"))

func fight(tinymon1: Tinymon_data, type: FIGHT_TYPE, tinymon2: Tinymon_data) -> WINNING_TYPE:
	var enemy_type = rng.randi_range(0, 2) as FIGHT_TYPE
	
	if enemy_type == type:
		return WINNING_TYPE.DRAW
	
	var won = false
	if type == FIGHT_TYPE.SCISSOR:
		if enemy_type == FIGHT_TYPE.STONE:
			won = false
		elif enemy_type == FIGHT_TYPE.PAPER:
			won = true
	elif type == FIGHT_TYPE.STONE:
		if enemy_type == FIGHT_TYPE.SCISSOR:
			won = true
		elif enemy_type == FIGHT_TYPE.PAPER:
			won = false
	elif type == FIGHT_TYPE.PAPER:
		if enemy_type == FIGHT_TYPE.SCISSOR:
			won = false
		elif enemy_type == FIGHT_TYPE.STONE:
			won = true
	
	if won:
		tinymon1.progress -=10
	else:
		tinymon1.progress +=10
	new_data.emit(tinymon1)
	
	if won:
		return WINNING_TYPE.WINNER
	else:
		return WINNING_TYPE.LOOSER
	
func fight_done(enemy: Tinymon_data):
	remove_enemy.emit(enemy)
