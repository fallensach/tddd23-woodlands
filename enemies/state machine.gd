extends Node

@export var initial_state: State
signal transition(new_state: String)

var current_state: State
var states: Dictionary = {}
var player: CharacterBody2D

# Called when the node enters the scene tree for the first time.
func _ready():
	self.transition.connect(on_state_transition)
	for child in get_children():
		if child is State:
			states[child.name.to_lower()] = child
			child.transition.connect(on_state_transition)

	if initial_state:
		initial_state.enter()
		current_state = initial_state

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float):
	if current_state:
		current_state.Update(delta)

func _physics_process(delta: float):
	if current_state:
		current_state.Physics_Update(delta)

func set_player(player: CharacterBody2D):
	self.player = player
	
func on_state_transition(new_state_name: String):
	var new_state = states[new_state_name]
	new_state.enter()
	current_state = new_state
