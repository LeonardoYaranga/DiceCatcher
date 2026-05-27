extends Area2D
class_name Dice

signal game_over
#Constants
const SPEED: float = 100.0
const ROTATION_SPEED: float = 5.0
@onready var sprite_2d: Sprite2D = $Sprite2D
var rotation_direction: float = 1

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if randf() < 0.5: rotation_direction *= -1

func _physics_process(delta: float) -> void:
	#dice fall
	position.y += SPEED * delta
	#dice spin in random direction
	sprite_2d.rotate(ROTATION_SPEED * delta * rotation_direction)
	check_game_over()
	

func check_game_over() -> void:
	if get_viewport_rect().size.y < position.y:
		game_over.emit()
		queue_free()
