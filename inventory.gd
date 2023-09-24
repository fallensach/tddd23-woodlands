extends Resource

class_name Inventory

signal item_added()
signal item_removed()
const MAX_ITEMS = 24
var items_size = 0

@export var items: Array[InventoryItem]

func full() -> bool:
	return items_size > MAX_ITEMS

func insert(item: InventoryItem) -> bool:
	for i in range(items.size()):
		if !items[i] and !full():
			item = item.duplicate()
			item.index = i
			items[i] = item
			item_added.emit()
			items_size += 1
			return true
		
	return false

func remove(item: InventoryItem) -> void:
	items[item.index] = null
	items_size -= 1
	item_removed.emit()
	
