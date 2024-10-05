extends CharacterBody2D

@export var speed = 400

@onready 
var fight_screen: CanvasLayer = %Fight

func get_input():
	var input_direction = Input.get_vector("left", "right", "up", "down")
	velocity = input_direction * speed

func _physics_process(delta: float) -> void:
	if fight_screen.visible: 
		return
		
	get_input()
	move_and_slide()
