class_name Fight extends CanvasLayer

var fight_stats: Fight_stats
var tinymon1: Tinymon_data
var tinymon2: Tinymon_data

enum STATE {IDLE, ATTACKER, DEFENDER, DONE}

var fight_result: Fight_result
var state: STATE = STATE.IDLE

@onready
var attacker_timer: Timer = %AttackerTimer
@onready
var defender_timer: Timer = %DefenderTimer

@onready
var action_label: Label = %Action

@onready
var attacker: Tinymon = %Attacker

@onready
var defender: Tinymon = %Defender

@onready
var explosion_scene = preload("res://prefabs/explosion/Explosion.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	hide()

func get_attack_name(attack_type: Global.FIGHT_TYPE) -> String:
	if attack_type == Global.FIGHT_TYPE.TACKLE:
		return "Tackle"
	if attack_type == Global.FIGHT_TYPE.FIRESTORM:
		return "Firestorm"
	if attack_type == Global.FIGHT_TYPE.FIREBALL:
		return "Fireball"
	if attack_type == Global.FIGHT_TYPE.FLOOD:
		return "Flood"
	if attack_type == Global.FIGHT_TYPE.SPLASH:
		return "Splash"
	if attack_type == Global.FIGHT_TYPE.EARTHQUAKE:
		return "Earthquake"
	if attack_type == Global.FIGHT_TYPE.METEOR:
		return "Meteor"
		
	return ""

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if fight_result == null:
		state = STATE.IDLE
		
	if state == STATE.IDLE:
		%Tackle.disabled = false
		%Firestorm.disabled = false
		%Fireball.disabled = false
		%Flood.disabled = false
		%Splash.disabled = false
		%Earthquake.disabled = false
		%Meteor.disabled = false
		
	elif state == STATE.ATTACKER:
		if attacker_timer.is_stopped():
			print("new stats1: ", fight_result.hpAttacker, " ", fight_result.hpDefender)	
			fight_stats.hpAttacker = fight_result.hpAttacker
			fight_stats.hpDefender = fight_result.hpDefender
			
			action_label.text = get_attack_name(fight_result.attacker_attack_type) + " >>"
			
			defender.add_child(explosion_scene.instantiate())
			attacker_timer.start()

	elif state == STATE.DEFENDER:
		if defender_timer.is_stopped():
			print("new stats2: ", fight_result.hpAttacker2, " ", fight_result.hpDefender2)	
			fight_stats.hpAttacker = fight_result.hpAttacker2
			fight_stats.hpDefender = fight_result.hpDefender2
			action_label.text =  "<< " + get_attack_name(fight_result.defender_attack_type)
			
			attacker.add_child(explosion_scene.instantiate())
			defender_timer.start()

	elif state == STATE.DONE:
		action_label.text = ""
		
		if fight_stats.hpAttacker <= 0 || fight_stats.hpDefender <= 0:
			visible = false
			Global.fight_done(tinymon2)
			
		state = STATE.IDLE
	
	else:
		state = STATE.IDLE
	
func _on_pressed(type: Global.FIGHT_TYPE) -> void:
	%Tackle.disabled = true
	%Firestorm.disabled = true
	%Fireball.disabled = true
	%Flood.disabled = true
	%Splash.disabled = true
	%Earthquake.disabled = true
	%Meteor.disabled = true
	
	fight_result = await Global.fight(tinymon1, type, fight_stats)
	state = STATE.ATTACKER
	
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


func _on_attacker_timer_timeout() -> void:
	if fight_result.hpAttacker <= 0 || fight_result.hpDefender <= 0:
		state = STATE.DONE
	else:
		state = STATE.DEFENDER

func _on_defender_timer_timeout() -> void:
	state = STATE.DONE
