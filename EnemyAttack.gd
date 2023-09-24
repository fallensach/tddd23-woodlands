extends State
class_name EnemyAttack

@export var enemy: EnemyBase
@export var move_speed: float

@onready var player: CharacterBody2D = get_node("../../../player")


func follow_target(target: CharacterBody2D):
	enemy.animation_player.play("run")
	enemy.velocity = (target.position - enemy.position).normalized() * move_speed
	enemy.look_towards(target.position - enemy.position)	

func enter():
	if enemy.name == "minotaur":
		enemy.enter_combat()

func Update(delta: float):
	if !player.is_alive:
		transition.emit("enemyidle")
	
	if !enemy.attacking and player.is_alive and !enemy.threat:
		follow_target(player)
	
func exit():
	pass

func Physics_Update(delta: float):
	pass
