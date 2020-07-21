extends PopupDialog

func _ready(): 
	PlayerStats.connect("display_popup_message", self, "message")

func message(text):
	get_node("Tween").interpolate_property(self, "modulate:a", 1.0, 0.0, 1, Tween.TRANS_LINEAR, Tween.EASE_OUT)
	get_node("Message").set_text(text)
	self.popup()

	var t = Timer.new()
	t.set_wait_time(2)
	t.set_one_shot(true)
	self.add_child(t)
	t.start()
	yield(t, "timeout")
	t.queue_free()

	get_node("Tween").start()
