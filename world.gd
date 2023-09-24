extends Node2D

@onready var mobTimer = $mobTimer
@onready var player = $player
@onready var ui = $UI

var max_slimes = 5
var mobs = []

func _ready():
	if !player.damaged.is_connected(ui._on_damage_taken):
		player.damaged.connect(ui._on_damage_taken)
	
	player.hp_updated.connect(ui._on_hp_updated)
	player.exp_gained.connect(ui._on_experience_gained)
	player.leveled_up.connect(ui._on_level_up)
	player.coin_collected.connect(ui._on_coin_collected)
	player.inventory.item_added.connect(ui.inventory._on_modified)
	player.inventory.item_removed.connect(ui.inventory._on_modified)
	$minotaur.mob_killed.connect(player._on_exp_gained)
	$slime.mob_killed.connect(player._on_exp_gained)
	mobTimer.start(1)

func spawn(node, type):
	var coin = load(type)
	var new_coin = coin.instantiate()
	new_coin.position = node.position
	call_deferred("add_child", new_coin, true)

func spawn_mob():
	var mob = load("res://enemies/slime.tscn")
	var new_mob: EnemyBase = mob.instantiate()
	var mob_spawn_location = get_node("mobPath/mobSpawner")
	new_mob.mob_killed.connect(player._on_exp_gained)
	mobs.append(new_mob)
	mob_spawn_location.progress_ratio = randf()
	new_mob.position = mob_spawn_location.position
	call_deferred("add_child", new_mob, true)


func _on_child_exiting_tree(node):
	if "enemy" in node:
		spawn(node, "res://misc/coin.tscn")
		spawn(node, "res://inventory/items/healthPot.tscn")


func _on_mob_timer_timeout():
	mobTimer.start(1)
	if mobs.size() <= max_slimes:
		pass
