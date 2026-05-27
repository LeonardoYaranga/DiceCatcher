extends Node2D

#escena dice
const DICE = preload("uid://c6wsbyjga68up")
const GAME_OVER = preload("uid://c0orcx0ncovyq")

@onready var spawn_timer: Timer = $Pausable/SpawnTimer
@onready var fox: Fox = $Pausable/Fox
@onready var score_label: Label = $ScoreLabel
@onready var music: AudioStreamPlayer = $Music
@onready var pausable: Node = $Pausable

const MARGIN: float = 80.
const STOPPABLE_GROUP: String = "stoppable"

var _points: int = 0

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("restart"):
		get_tree().reload_current_scene()
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	get_tree().paused = false
	spawn_timer.timeout.connect(spawn_dice)
	spawn_timer.start()
	fox.dice_caught.connect(_on_dice_caught)

func update_score_label() -> void:
	score_label.text = "%04d" % _points
	print("_points", _points)
	
func spawn_dice() -> void:
	var new_dice: Dice = DICE.instantiate()
	new_dice.game_over.connect(_on_game_over)
	var screen_vpr: Rect2 = get_viewport_rect()
	var random_x: float = randf_range(screen_vpr.position.x + MARGIN, screen_vpr.end.x - MARGIN)
	new_dice.position = Vector2(random_x, -MARGIN)
	pausable.add_child(new_dice)

func pause_all() -> void:
	var to_stop: Array[Node] = get_tree().get_nodes_in_group(STOPPABLE_GROUP)
	for node in to_stop:
		node.set_physics_process(false)
	spawn_timer.stop()
	
func _on_dice_caught() -> void:
	_points += 1
	
		
func _on_game_over() -> void:
	print("Game Over")
	#pause_all()
	music.stop()
	music.stream = GAME_OVER
	music.play()
	get_tree().paused = true
