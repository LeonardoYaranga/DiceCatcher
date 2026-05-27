extends Area2D

class_name Fox

@export var speed: float = 200.0

func _physics_process(delta: float) -> void:
	var move: float = 0.0
	if Input.is_action_pressed("ui_right"):
		move = speed
	if Input.is_action_pressed("ui_left"):
		move = - speed
	position.x += move * delta
