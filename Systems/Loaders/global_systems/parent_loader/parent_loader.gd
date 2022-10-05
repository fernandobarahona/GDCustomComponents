extends Node2D

var bks = [null]

func _ready():
	pass

func load_scenes():
	bks[0] = load("res://backgrounds/background_theme_1.tscn")

func unload_scenes():
	bks[0] = null
