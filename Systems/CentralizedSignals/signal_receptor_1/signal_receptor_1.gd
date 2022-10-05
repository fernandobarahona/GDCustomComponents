extends Label

#var emmiter_node: Node = null

func _ready():
	self._update_text("", "")
# warning-ignore:return_value_discarded
	CentralizedSignals.connect('custom_signal_1', self, "_update_text",[self])

func _update_text(emmiter_node, reciber_node):
	self.text = "A label to test signals:\n* Signal send from: "+ str(emmiter_node.name if emmiter_node else "") + "\n* Signal recieved by: " + str(reciber_node.name if reciber_node else "")
