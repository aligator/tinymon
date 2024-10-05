extends Node2D

@export 
var tinymon_data: Tinymon_data = Tinymon_data.new()

@onready
var tinymon: Tinymon = %Tinymon

var enemy_prefab = preload("res://prefabs/tinymon/Enemy.tscn")

var rng = RandomNumberGenerator.new()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	tinymon.set_data(Global.tinymon)
	spawn_enemy(true)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func spawn_enemy(in_screen: bool = false):
	var instance: Enemy = enemy_prefab.instantiate()
	
	var screen_size = get_viewport_rect().size
	
	var x_modifier = screen_size[0]
	var y_modifier = screen_size[1]
	
	if in_screen:
		x_modifier = 64
		y_modifier = 64
	
	var x = rng.randi_range(-screen_size[0]/2, screen_size[0]/2)
	var y = rng.randi_range(-screen_size[1]/2, screen_size[1]/2)
	
	if x < -screen_size[0]/2:
		x_modifier *= -1
		
	if y < -screen_size[1]/2:
		y_modifier *= -1
	
	instance.position = Vector2(position[0] + x_modifier + x, position[1] + y_modifier + y)
	add_child(instance)
	instance.set_tinymon(Global.new_enemy())
	instance.start_fight.connect(on_start_fight)

func on_start_fight(enemy: Enemy):
	print(enemy.tinymon.tinymon)
