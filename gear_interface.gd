extends Control

var is_open = false
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func _on_gui_input(event):
	if event.is_action_pressed("gear"):
		opener()

func opener():
	if is_open:
		is_open = false
		self.set_visible(false)
		
	else:
		is_open = true
		self.set_visible(true)
