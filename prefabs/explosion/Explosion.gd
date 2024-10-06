extends GPUParticles2D

func _ready():
	one_shot = true
	emitting = true

func _on_timer_timeout():
	queue_free()
