extends Area2D

@export var itemRes: InventoryItem
@onready var aliveTime: Timer = $Timer

func _ready():
	aliveTime.start(10)

func _on_body_entered(body):
	if body.name == "player":
		if body.collect(itemRes):
			queue_free()


func _on_timer_timeout():
	queue_free()
