extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -400.0

@onready var health_bar = $healthBar
@onready var animation_player = $AnimationPlayer
@onready var damageBar = $damageTaken
@onready var sprite = $Sprite2D
@onready var attack_cd = $attackCooldown
@onready var player = get_node("../player")


# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var hp = 100
var attack = 10
var attack_cooldown = false
@onready var exp = (200 * player.level / player.level ** 2) + 100

var targets = []
var enemy = true
var alive = true

func _ready():
	init_hp()

func give_exp(experience):
	player.exp_gained.emit(experience)
	player.exp += experience
	
func attack_target():
	if !attack_cooldown:
		for target in targets:
			if target.is_alive:
				attack_cooldown = true
				attack_cd.start(0.5)
				target.take_damage(attack)

func knockback(direction):
	velocity += direction
	await get_tree().create_timer(0.2).timeout
	velocity = Vector2(0, 0)

func display_damage(damage):
	damageBar.set_visible(true)
	damageBar.set_text(str(damage))
	await get_tree().create_timer(2).timeout
	damageBar.set_visible(false)
	
func init_hp():
	health_bar.set_max(hp)
	health_bar.set_value(hp)

func get_hit(damage, direction):
	knockback(direction)
	display_damage(damage)
	sprite.modulate = Color.RED
	await get_tree().create_timer(0.1).timeout
	sprite.modulate = Color.WHITE
	hp -= damage
	health_bar.set_value(hp)

func _physics_process(delta):
	attack_target()
	if hp <= 0:
		alive = false
		animation_player.play("death")
		await get_tree().create_timer(1).timeout
		
	move_and_slide()
	
func _on_animation_player_animation_finished(anim_name):
	if anim_name == "death":
		give_exp(exp)
		player.try_level()
		queue_free()


func _on_attack_range_body_entered(body):
	if body.name == "player":
		targets.append(body)

func _on_attack_cooldown_timeout():
	attack_cooldown = false


func _on_attack_range_body_exited(body):
	if body.name == "player":
		targets.remove_at(0)

