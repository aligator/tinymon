extends Node

@export var http: AwaitableHTTPRequest

var server: String = "http://localhost:5119"

var rng = RandomNumberGenerator.new()

var tinymon: Tinymon_data = Tinymon_data.new()

var code_used: bool = false

enum FIGHT_TYPE {TACKLE, FIRESTORM, FIREBALL, FLOOD, SPLASH, EARTHQUAKE, METEOR}

signal new_data
signal remove_enemy

func load_tinymon(code: String):
	# Call api
	var resp := await http.async_request(
		server + "/Tinymon/" + code, 
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
		code_used = true
	
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
		var enemy = Tinymon_data.new(json.id, json.name, img, json.level, json.progress, json.elementType)
		return enemy
	
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

func fight(attacker: Tinymon_data, type: FIGHT_TYPE, fight_stats: Fight_stats) -> Fight_result:
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
		
		tinymon.level = json.fightBack.attacker.level
		tinymon.progress = json.fightBack.attacker.progress

		new_data.emit(tinymon)
		
		var fight_result: Fight_result = Fight_result.new(
			json.fight.id,
			json.fight.hpAttacker,
			json.fight.hpDefender,
			json.fightBack.hpAttacker,
			json.fightBack.hpDefender,
			type,
			json.fightBackAttack,
			json.fight.hpAttacker > 0 && json.fight.hpDefender > 0
		)
		return fight_result
		
	assert("api call should work")
	return
				
func fight_done(enemy: Tinymon_data):
	remove_enemy.emit(enemy)
