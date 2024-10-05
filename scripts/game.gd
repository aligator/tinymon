extends Node2D

@onready
var tinymon: Tinymon = %Tinymon

@onready 
var fight_screen: Fight = %Fight

var enemy_prefab = preload("res://prefabs/tinymon/Enemy.tscn")

var enemies: Array[Enemy] = []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Global.remove_enemy.connect(on_remove_enemy)
	tinymon.set_data(Global.tinymon)
	spawn_enemy(true)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func on_remove_enemy(to_be_removed: Tinymon_data):
	print("remove")
	for i in len(enemies):
		var enemy = enemies[i]
		if enemy.tinymon.tinymon.tinymon_name == to_be_removed.tinymon_name:
			enemies.pop_at(i)
			enemy.queue_free()
			spawn_enemy(true)
			break	

func spawn_enemy(in_screen: bool = false):
	var instance: Enemy = enemy_prefab.instantiate()
	
	var screen_size = get_viewport_rect().size
	
	var x_modifier = screen_size[0]
	var y_modifier = screen_size[1]
	
	if in_screen:
		x_modifier = 64
		y_modifier = 64
	
	var x = Global.rng.randi_range(-screen_size[0]/2+64, screen_size[0]/2-64)
	var y = Global.rng.randi_range(-screen_size[1]/2+64, screen_size[1]/2-64)
	
	if x < -screen_size[0]/2:
		x_modifier *= -1
		
	if y < -screen_size[1]/2:
		y_modifier *= -1
	
	instance.position = Vector2(position[0] + x_modifier + x, position[1] + y_modifier + y)
	add_child(instance)
	instance.set_tinymon(Global.new_enemy())
	instance.start_fight.connect(on_start_fight)
	enemies.append(instance)

func on_start_fight(enemy: Enemy):
	fight_screen.tinymon1 = self.tinymon.tinymon
	fight_screen.tinymon2 = enemy.tinymon.tinymon
	fight_screen.visible = true
