extends Node2D

onready var icon_selector = $IconSelector

onready var showed_number = $Number

var selected_option_index : int

func _ready():
# warning-ignore:return_value_discarded
	icon_selector.connect("item_selected", self, "_on_item_selected")
	showed_number.text = str($IconSelector.selected_item_id)
	
func _on_item_selected(selected_item_index, _parent_selector):
	selected_option_index = selected_item_index
	showed_number.text = str(selected_item_index)
	
func _on_Plus_pressed():
	$IconSelector.selected_item_id += 1 

func _on_Minus_pressed():
	$IconSelector.selected_item_id -= 1 
