extends ProgressBar


func initialize(hp):
	self.set_max(hp)

func _on_canvas_layer_health_changed(health):
	self.set_value(health)
