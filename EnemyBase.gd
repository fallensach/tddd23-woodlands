extends CharacterBody2D
class_name EnemyBase

signal mob_killed(exp)

@export var enemy: EnemyBase
@export var sprite: Sprite2D
@export var health_bar: ProgressBar
@export var animation_player: AnimationPlayer
@export var damage_bar: Label
@export var detection_range: Area2D
@export var attack_cd: Timer
@export var attack_range: Area2D

var target: CharacterBody2D
var hp: int
var max_hp: int
var attack: int
var alive: bool
var experience: int
var attack_cooldown: bool = false
var attacking: bool = false
var flipped: bool = false
var threat: bool = false
@onready var scale_x = self.scale.x
@onready var scale_y = self.scale.y

func death():
	if hp <= 0:
		alive = false
		animation_player.play("death")
		await get_tree().create_timer(animation_player.current_animation_length).timeout
		mob_killed.emit(experience)
		queue_free()

func give_exp(experience):
	mob_killed.emit(experience)

func init_hp():
	health_bar.max_value = max_hp
	health_bar.value = hp

func look_towards(dir: Vector2):
	if dir.x > 0:
		self.rotation_degrees = 0
		self.scale.y = scale_y
		
	else:
		self.scale.y = -scale_y
		self.rotation_degrees = 180

func play_animation(anim_name: String):
	animation_player.play(anim_name)

func attack_target(target: CharacterBody2D):
	pass

func knockback(direction):
	velocity += direction
	await get_tree().create_timer(0.2).timeout
	velocity = Vector2(0, 0)

func display_damage(damage):
	damage_bar.set_visible(true)
	damage_bar.set_text(str(damage))
	await get_tree().create_timer(2).timeout
	damage_bar.set_visible(false)

func get_hit(damage, direction):
	knockback(direction)
	display_damage(damage)
	sprite.modulate = Color.RED
	await get_tree().create_timer(0.1).timeout
	sprite.modulate = Color.WHITE
	hp -= damage
	health_bar.value = hp
	death()

func _on_detection_range_body_entered(body):
	if body.name == "player" and body.is_alive:
		self.target = body
		$State.transition.emit("enemyattack")
		$State.set_player(body)

func _on_detection_range_body_exited(body):
	self.target = null
	if body.name == "player":
		$State.transition.emit("enemyidle")

func _on_attack_cooldown_timeout():
	attack_cooldown = false

func _on_attack_range_body_entered(body):
	if body.name == "player":
		print("play")
		attack_target(target)
		if !body.is_alive:
			$State.transition.emit("enemyidle")


