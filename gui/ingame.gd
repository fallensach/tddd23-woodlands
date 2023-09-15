extends CanvasLayer

signal health_changed(health)
signal coins_changed(coins)
signal exp_changed(experience)

@onready var player = get_node("../player")

var hp_regen = 0:
	set(new_hp_regen):
		hp_regen = player.health_regen

var level = 0:
	set(new_level):
		level = new_level
		_update_level()

var coins = 0:
	set(new_coins):
		coins = new_coins
		_update_coin_label()

var max_experience = 0
var experience = 0:
	set(new_experience):
		experience = new_experience
		_update_exp()

var max_hp = 0
var hp = 0:
	set(new_hp):
		hp = new_hp
		_update_health()

func _ready():
	hp = player.hp
	max_hp = player.max_hp
	max_experience = player.max_exp
	experience = player.exp
	coins = player.coins
	
	_update_exp()
	$Control/expBar.set_max(max_experience)
	_update_coin_label()
	_update_level()
	_update_health()

func _update_coin_label():
	$Control/eventCoin/resources/HBoxContainer/coins.set_text(str(coins))

func _on_coin_collected():
	coins = player.coins

func _update_health():
	$healthBar/healthText.set_text(str(hp) + "/" + str(max_hp))
	$healthBar.set_value(hp)

func _on_damage_taken(damage):
	hp -= damage
	if hp < 0:
		hp = 0

func _on_hp_updated(new_hp):
	hp = new_hp

func _update_level():
	$Control/levelBg/levelContainer/level.set_text(str(player.level))
	$healthBar.set_max(player.max_hp)
	$healthBar.set_value(hp)

func _update_exp():
	$Control/expBar.set_tooltip_text(str(experience) + "/" + str(max_experience))
	$Control/expBar.set_value(experience)

func _on_experience_gained(new_exp):
	$Control/expBar.set_tooltip_text(str(experience) + "/" + str(max_experience))
	experience += new_exp

func _on_level_up(new_max_exp, exp_overflow):
	max_hp = player.max_hp
	hp = max_hp
	level = player.level
	max_experience = new_max_exp
	experience = exp_overflow
	$Control/expBar.set_max(new_max_exp)
	$Control/expBar.set_value(0)
	
func _on_inventory_pressed():
	pass # Replace with function body.
