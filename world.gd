extends Node2D

@onready var mobTimer = $mobTimer
@onready var player = $player
@onready var ui = $UI

func _ready():
	if !player.damaged.is_connected(ui._on_damage_taken):
		player.damaged.connect(ui._on_damage_taken)
	
	player.hp_updated.connect(ui._on_hp_updated)
	player.exp_gained.connect(ui._on_experience_gained)
	player.leveled_up.connect(ui._on_level_up)
	player.coin_collected.connect(ui._on_coin_collected)
	
	mobTimer.start(1)

func spawn(node):
	var coin = load("res://misc/coin.tscn")
	var new_coin = coin.instantiate()
	new_coin.position = node.position
	call_deferred("add_child", new_coin, true)

func spawn_mob():
	var mob = load("res://enemies/slime.tscn")
	var new_mob = mob.instantiate()
	var mob_spawn_location = get_node("mobPath/mobSpawner")
	mob_spawn_location.progress_ratio = randf()
	new_mob.position = mob_spawn_location.position
	call_deferred("add_child", new_mob, true)
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	

func _on_child_exiting_tree(node):
	if "enemy" in node:
		spawn(node)


func _on_mob_timer_timeout():
	mobTimer.start(1)
	spawn_mob()
