extends Area2D

@onready var sprite = $Sprite2D
@onready var player = get_node("../../../player")
@onready var weapon_tip = $weaponTip

var attacking = false

func _on_body_entered(body):
	if "enemy" in body and attacking:
		body.get_hit(player.player_damage(), body.position - player.position)

func _on_weapon_anim_animation_finished(anim_name):
		attacking = false
