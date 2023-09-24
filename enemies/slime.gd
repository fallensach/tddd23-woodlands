extends EnemyBase

const SPEED = 300.0
@onready var player = get_node("../player")

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var dash_cooldown = false
var moving = true
var dashing = false

func _ready():
	hp = 100
	attack = 10
	max_hp = 100
	experience = (200 * player.level / player.level ** 2) + 100
	alive = true
	init_hp()

func attack_target(target: CharacterBody2D):
	if !dash_cooldown:
		dash_cooldown = true
		attacking = true
		dashing = true
		windup()
	
func hit(target: CharacterBody2D):
	if !attack_cooldown:
		attack_cooldown = true
		attack_cd.start(0.5)
		target.take_damage(attack, target.position - self.position)

func windup():
	animation_player.play("windup")
	self.velocity = Vector2.ZERO
	$dashWindup.start(1)

func dash_attack():
	animation_player.speed_scale = 1
	animation_player.play("run")
	self.velocity = (player.position - self.position).normalized() * 400
	$dashCooldown.start(2)
	$dashTime.start(0.5)
	
func _physics_process(delta):
	if alive:
		attack_target(player)
		move_and_slide()

func _on_timer_timeout():
	attacking = false
	$Timer.start(2)
	
func _on_dash_cooldown_timeout():
	dash_cooldown = false

func _on_dash_time_timeout():
	attacking = false
	dashing = false
	
func _on_detection_range_body_entered(body):
	if body.name == "player" and body.is_alive:
		$State.transition.emit("enemyattack")
		$State.set_player(body)
		attack_target(body)

func _on_attack_range_body_entered(body):
	if body.name == "player":
		hit(body)
		if !body.is_alive:
			$State.transition.emit("enemyidle")

func _on_dash_windup_timeout():
	dash_attack()
