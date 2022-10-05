extends Node2D

func _ready():
# warning-ignore:return_value_discarded
	CentralizedSignals.connect('custom_signal_1', self, 'on_custom_signal_1_detected')
	
func on_custom_signal_1_detected(emmiter_node):
	printt('custom_signal_1 from: ', str(emmiter_node.name))
