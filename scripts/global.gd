extends Node

@export var http: AwaitableHTTPRequest

var server: String = "http://localhost:5119"

var rng = RandomNumberGenerator.new()

var tinymon: Tinymon_data = Tinymon_data.new()

enum FIGHT_TYPE {TACKLE, FIRESTORM, FIREBALL, FLOOD, SPLASH, EARTHQUAKE, METEOR}
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
		tinymon = Tinymon_data.new(json.id, json.name, img, json.level, json.progress, json.elementType)

func new_enemy() -> Tinymon_data:	
	# Call api
	var resp := await http.async_request(
		server + "/Tinymon/" + tinymon.id + "/enemy?level="+str(tinymon.level), 
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
		tinymon = Tinymon_data.new(json.id, json.name, img, json.level, json.progress, json.elementType)
		return tinymon
	
	return Tinymon_data.new("00000000-0000-0000-0000-000000000000", "enemy", Image.load_from_file("res://assets/img/tinymon.png"))

func start_fight(attacker: Tinymon_data, defender: Tinymon_data) -> Fight_stats:
	# Call api
	var resp := await http.async_request(
		server + "/Tinymon/" + attacker.id + "/enemy/" + defender.id + "/fight", 
		PackedStringArray([
			"content-type: application/json",
		]), 
		HTTPClient.Method.METHOD_POST, 
	)
	if resp.success():
		var json = resp.body_as_json()
		var stats = Fight_stats.new(json.id, json.hpAttacker, json.hpDefender)
		return stats
		
	assert("error start fight")
	return

func fight(attacker: Tinymon_data, type: FIGHT_TYPE, fight_stats: Fight_stats) -> WINNING_TYPE:
	# Call api
	var data_to_send = {
	  "attack": type,
	}
	var json_string = JSON.stringify(data_to_send)
	
	var resp := await http.async_request(
		server + "/Tinymon/" + attacker.id + "/fight/" + fight_stats.fightId, 
		PackedStringArray([
			"content-type: application/json",
		]), 
		HTTPClient.Method.METHOD_PATCH,
		json_string
	)
	if resp.success():
		var json = resp.body_as_json()
		fight_stats.hpAttacker = json.fightBack.hpAttacker
		fight_stats.hpDefender = json.fightBack.hpDefender
		
		attacker.level = json.fightBack.attacker.level
		attacker.progress = json.fightBack.attacker.progress
		new_data.emit(attacker)
		
		if fight_stats.hpAttacker == 0 && fight_stats.hpDefender:
			return WINNING_TYPE.DRAW
		if fight_stats.hpAttacker <= 0:
			return WINNING_TYPE.LOOSER
		if fight_stats.hpDefender <= 0:
			return WINNING_TYPE.WINNER
	
	return WINNING_TYPE.DRAW
				
func fight_done(enemy: Tinymon_data):
	remove_enemy.emit(enemy)
