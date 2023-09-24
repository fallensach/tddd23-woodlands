extends Control

var is_open = false
var dragging = false

@onready var inventory: Inventory = preload("res://inventory/playerInventory.tres")
@onready var slots = $invSprite/inventorySlots.get_children()

func drag() -> void:
	self.position += get_local_mouse_position()

func _physics_process(delta):
	if dragging:
		drag()

func connect_signals():
	for slot in slots:
		slot.item_used.connect(self._on_item_used)

func _ready():
	connect_signals()
	update()
	close()

func _on_item_used(item):
	inventory.remove(item)

func _on_modified():
	update()

func update():
	for item in range(inventory.items.size()): 
		slots[item].update(inventory.items[item])
		# Check that empty inventory slots are not iterated
		if inventory.items[item]:
			slots[item].item = inventory.items[item]
			slots[item].itemContainer.tooltip_text = inventory.items[item].description
		else:
			slots[item].itemContainer.tooltip_text = ""

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

func _on_gui_input(event):
	if event.is_action_pressed("drag"):
		dragging = true
		
	if event.is_action_released("drag"):
		dragging = false
