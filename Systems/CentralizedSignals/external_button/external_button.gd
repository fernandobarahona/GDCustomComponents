extends Button

func _on_ExternalButton_pressed():
	CentralizedSignals.emit_signal("custom_signal_1", self)
