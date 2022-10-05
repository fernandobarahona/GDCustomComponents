extends Node2D


func _on_Plus_button_down():
	$ArrowSelector.selected_item_position += 1

func _on_Minus_button_down():
	$ArrowSelector.selected_item_position -= 1
