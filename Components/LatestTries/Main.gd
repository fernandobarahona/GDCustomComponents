extends Node2D

func _on_CorrectTry_pressed():
	$LatestTries.new_try(true)
	pass # Replace with function body.

func _on_WrongTry_pressed():
	$LatestTries.new_try(false)
	pass # Replace with function body.
