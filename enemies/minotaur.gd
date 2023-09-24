extends EnemyBase

const SPEED = 300.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

@onready var player = get_node("../player")

func _ready():
	hp = 1000
	attack = 50
	max_hp = 1000
	experience = (4000 * player.level / player.level ** 2) + 2000
	alive = true
	init_hp()

func attack_target(target: CharacterBody2D):
	attacking = true
	self.velocity = Vector2.ZERO
	play_animation("attack")

func _physics_process(delta):
	if alive and !threat:
		move_and_slide()

func enter_combat():
	look_towards(player.position - self.position)
	play_animation("threat")
	threat = true
	await get_tree().create_timer(animation_player.current_animation_length).timeout
	threat = false

func _on_animation_player_animation_finished(anim_name: String):
	if anim_name == "attack":
		attacking = false
		
func _on_attack_body_entered(body: CharacterBody2D):
	if body.name == "player":
		body.take_damage(self.attack, body.position-self.position)


