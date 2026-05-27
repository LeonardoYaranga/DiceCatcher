extends Node2D

#escena dice
const DICE = preload("uid://c6wsbyjga68up")
@onready var spawn_timer: Timer = $SpawnTimer
const MARGIN: float = 80.0
const STOPPABLE_GROUP: String = "stoppable"

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("restart"):
		get_tree().reload_current_scene()
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	spawn_timer.timeout.connect(spawn_dice)
	spawn_timer.start()
	
func spawn_dice() -> void:
	var new_dice: Dice = DICE.instantiate()
	new_dice.game_over.connect(_on_game_over)
	var screen_vpr: Rect2 = get_viewport_rect()
	var random_x: float = randf_range(screen_vpr.position.x + MARGIN, screen_vpr.end.x - MARGIN)
	new_dice.position = Vector2(random_x, -MARGIN)
	add_child(new_dice)

func pause_all() -> void:
	var to_stop: Array[Node] = get_tree().get_nodes_in_group(STOPPABLE_GROUP)
	for node in to_stop:
		node.set_physics_process(false)
	spawn_timer.stop()
		
func _on_game_over() -> void:
	print("Game Over")
	pause_all()
