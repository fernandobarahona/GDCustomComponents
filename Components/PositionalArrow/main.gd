extends Node2D

func _ready():
	pass # Replace with function body.


func _on_TextureButton_pressed():
	print($TextureButton.rect_position.x + $TextureButton.rect_size.x)
	$PositionalArrow.pointer_x_position = $TextureButton.rect_position.x + $TextureButton.rect_size.x / 2


func _on_TextureButton2_pressed():
	print($TextureButton2.rect_position.x + $TextureButton2.rect_size.x / 2)
	$PositionalArrow.pointer_x_position = $TextureButton2.rect_position.x + $TextureButton2.rect_size.x / 2
