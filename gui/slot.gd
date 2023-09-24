extends Panel

signal item_used(item: InventoryItem)

@onready var backgroundSprite: Sprite2D = $slotSprite
@onready var itemSprite: Sprite2D = $itemContainer/Panel/item
@onready var itemContainer: CenterContainer = $itemContainer
@onready var item: InventoryItem

func update(item: InventoryItem) -> void:
	if !item:
		backgroundSprite.frame = 0
		itemSprite.visible = false
		
	else:
		backgroundSprite.frame = 1
		itemSprite.visible = true
		itemSprite.texture = item.texture


func _on_gui_input(event):
	if item and event.is_action_pressed("use") and item.consumable:
		item_used.emit(item)
