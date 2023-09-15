extends Area2D

@onready var sprite = $Sprite2D
@onready var player = get_node("../../../player")
@onready var weapon_tip = $weaponTip

var attacking = false
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_body_exited(body):
	pass # Replace with function body.

func _on_body_entered(body):
	if "enemy" in body and attacking:
		body.get_hit(player.player_damage(), sprite.position)

func _on_weapon_anim_animation_finished(anim_name):
		attacking = false
