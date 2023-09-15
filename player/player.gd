extends CharacterBody2D

const SPEED = 150.0
signal damaged(damage)
signal hp_updated(hp)
signal exp_gained(exp)
signal leveled_up()
signal coin_collected()

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
@onready var character_animation = $characterAnim
@onready var weapon_animation = $weaponAnim
@onready var player_sprite = $characterSprite
@onready var weapon = $weaponAxis/sword
@onready var vfx_animation = $vfxAnim
@onready var weapon_axis = $weaponAxis
@onready var attackHitBox = $attackRange/attackHitBox
@onready var attack_timer = $Timer
@onready var hand = $hand
@onready var regenTimer = $healthRegenTimer

var directions = {
	"side": "idleSide",
}

var current_facing = Vector2(0,0)

# Player stats
var exp = 0
var coins = 0
var level = 1
var max_exp = roundi(1000 * 1.13**level)
var str = 1
var hlt = 1
var agi = 5
var max_hp = (100 + (hlt * 5)) * level ** 1.03
var hp = max_hp
var damage = (102 + (str * 3)) + level ** 1.05
var max_damage = damage * 1.1
var min_dmg = damage * 0.9
var attack_speed = 1 / (1.05 ** agi)
var attack_cooldown = false
var is_alive = true
var health_regen = 0.5

var nearby_loot = []
var idle = "idleFront"
var dir = "side"
var is_attacking = false
var looting = false
var level_up = false
var dashing = false
var dash_cd = false

func _ready():
	regenTimer.start(1)

func player_damage():
	return randi_range(min_dmg, max_damage)

func take_damage(damage):
	damaged.emit(damage)
	hp -= damage
	if hp <= 0:
		is_alive = false
		character_animation.play("death")
		
	player_sprite.modulate = Color.RED
	await get_tree().create_timer(0.1).timeout
	player_sprite.modulate = Color.WHITE

func attack(dir, vel, attack_type):
	if !attack_cooldown:
		weapon_animation.set_speed_scale(attack_speed**-1)
		if !attack_type:
			weapon_animation.play("attack_1")
		else:
			weapon_animation.play("attack_spin")
		attack_timer.start(attack_speed)
		attack_cooldown = true

func collect_loot():
	for loot in nearby_loot:
		var direction = self.position - loot.position
		loot.velocity = direction * 10
	
func get_input():
	var input_direction = Input.get_vector("left", "right", "up", "down")
	if input_direction.x > 0 :
		weapon_axis.scale.x = 1
		player_sprite.flip_h = false
		current_facing = input_direction
		character_animation.play("runSide")
		
	elif input_direction.x < 0:
		weapon_axis.scale.x = -1
		player_sprite.flip_h = true
		current_facing = input_direction
		character_animation.play("runSide")
			
	elif input_direction.y > 0:
		current_facing = input_direction
		character_animation.play("runSide")
	
	elif input_direction.y < 0:
		current_facing = input_direction
		character_animation.play("runSide")
		
	else:
		character_animation.play("idleSide")
 
	velocity = input_direction * SPEED

func level_stats(str, agi, hlt):
	self.str += str
	self.agi += agi
	self.hlt += hlt

func try_level():
	if exp >= max_exp:
		exp =  abs(max_exp - exp) 
		max_exp = roundi(1000 * 1.3**level)
		level += 1
		level_stats(1, 1, 1)
		update_stats()
		vfx_animation.play("level_up")
		leveled_up.emit(max_exp, exp)

func update_stats():
	max_hp = roundi((100 + (hlt * 5)) + level ** 1.03)
	hp = max_hp
	damage = (10 + (str * 3)) + level ** 1.05
	max_damage = damage * 1.1
	min_dmg = damage * 0.9
	attack_speed = 1 / (1.05 ** agi)

func _physics_process(delta):
	try_level()
	if looting:
		collect_loot()
	
	if !is_attacking:
		var pos = (Vector2(
			player_sprite.get_local_mouse_position()
		))
		
	if is_alive:
		if !dashing:
			get_input()
			
		if Input.is_action_pressed("dash") and !dash_cd:
			$dashCooldown.start(2)
			vfx_animation.queue("dash")
			velocity = velocity * 2
			dash_cd = true
			dashing = true
			await get_tree().create_timer(0.3).timeout
			dashing = false
			
		if Input.is_action_pressed("attack") or Input.is_action_pressed("attack_2"):
			attack(dir, current_facing, Input.is_action_pressed("attack_2"))
			is_attacking = true
			weapon.attacking = true
		
		move_and_slide()


func _on_character_anim_animation_finished(anim_name):
	if anim_name == "death":
		print("dead")

func _on_timer_timeout():
	weapon_animation.set_speed_scale(1)
	attack_cooldown = false

func _on_weapon_anim_animation_finished(anim_name):
		if "attack" in anim_name:
			weapon_animation.play("idle")

func _on_loot_area_body_entered(body):
	if "coin" in body.name:
		nearby_loot.append(body)
		looting = true

func _on_loot_area_body_exited(body):
	if "coin" in body.name:
		body.velocity = Vector2(0,0)
		nearby_loot.remove_at(nearby_loot.find(body))

func _on_collect_range_body_entered(body):
	if "coin" in body.name:
		coins += 1
		coin_collected.emit()
		body.queue_free()
	
func _on_health_regen_timeout():
	if hp < max_hp:
		hp += health_regen
		hp_updated.emit(hp)
	
	regenTimer.start(1)


func _on_dash_cooldown_timeout():
	dash_cd = false
