extends Node2D


func _on_Plus_pressed():
	$ArrowProgressBar.value += 1


func _on_Minus_pressed():
	$ArrowProgressBar.value -= 1
