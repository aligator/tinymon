extends Node

@export var http: AwaitableHTTPRequest

var server: String = "http://localhost:5119"

var rng = RandomNumberGenerator.new()

var tinymon: Tinymon_data = Tinymon_data.new()

enum FIGHT_TYPE {SCISSOR, STONE, PAPER}
enum WINNING_TYPE {LOOSER, DRAW, WINNER}

signal new_data
signal remove_enemy

func new_tinymon(tinymon_data: Tinymon_data):
	tinymon_data.image.resize(64, 64)

	# Call api
	var data_to_send = {
	  "name": tinymon_data.tinymon_name,
	  "image": Marshalls.raw_to_base64(tinymon_data.image.save_png_to_buffer()),
	  "elementType": tinymon_data.element_type,
	}
	var json_string = JSON.stringify(data_to_send)
	var resp := await http.async_request(
		server + "/Tinymon", 
		PackedStringArray([
			"content-type: application/json",
		]), 
		HTTPClient.Method.METHOD_POST, 
		json_string
	)
	if resp.success():
		var json = resp.body_as_json()
		var img = Image.new()
		#'image' is the resulted base64 string from the API
		img.load_png_from_buffer(Marshalls.base64_to_raw(json.image))
		tinymon = Tinymon_data.new(json.name, img, json.level, json.progress, json.elementType)

func new_enemy() -> Tinymon_data:
	# Call api
	var resp := await http.async_request(
		server + "/Tinymon/enemy?level="+str(tinymon.level), 
		PackedStringArray([
			"content-type: application/json",
		]),
		HTTPClient.Method.METHOD_GET, 
	)
	if resp.success():
		var json = resp.body_as_json()
		var img = Image.new()
		#'image' is the resulted base64 string from the API
		img.load_png_from_buffer(Marshalls.base64_to_raw(json.image))
		tinymon = Tinymon_data.new(json.name, img, json.level, json.progress, json.elementType)
		return tinymon
	
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
