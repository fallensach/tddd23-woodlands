extends Control

var is_open = false

@onready var inventory: Inventory = preload("res://inventory/playerInventory.tres")
@onready var slots = $invSprite/inventorySlots.get_children()

func _ready():
	update()

func update():
	for item in range(min(inventory.items.size(), slots.size())):
		slots[item].update(inventory.items[item])
		# Check that empty inventory slots are not iterated
		if inventory.items[item]:
			slots[item].itemContainer.tooltip_text = inventory.items[item].description

func open():
	is_open = true
	self.set_visible(true)
	
func close():
	is_open = false
	self.set_visible(false)

func handler():
	if is_open:
		close()
	else:
		open()
