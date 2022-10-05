extends Node2D


func _on_MinusBtn_pressed():
	$CircularProgressBar.value -= 1

func _on_PlusBtn_pressed():
	$CircularProgressBar.value += 1

func _on_Minus10Btn_pressed():
	$CircularProgressBar.value -= 10

func _on_Plus10Btn_pressed():
	$CircularProgressBar.value += 10
