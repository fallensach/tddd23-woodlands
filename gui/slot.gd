extends Panel

@onready var backgroundSprite: Sprite2D = $slotSprite
@onready var itemSprite: Sprite2D = $itemContainer/Panel/item
@onready var itemContainer: CenterContainer = $itemContainer

func update(item: InventoryItem):
	if !item:
		backgroundSprite.frame = 0
		itemSprite.visible = false
		
	else:
		backgroundSprite.frame = 1
		itemSprite.visible = true
		itemSprite.texture = item.texture
