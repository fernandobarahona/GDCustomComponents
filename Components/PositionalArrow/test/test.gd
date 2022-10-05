tool
extends Node2D

export var exported_var := 5 setget set_exported_var


func _ready():
	pass # Replace with function body.

func set_exported_var(new_value):
	print(new_value)
	exported_var = new_value
