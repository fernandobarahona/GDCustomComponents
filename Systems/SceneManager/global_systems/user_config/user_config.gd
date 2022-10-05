extends Node

var theme = "theme_1"
var sprite_effect_time = 2 setget set_sprite_effect_time

func set_sprite_effect_time(new_value):
	sprite_effect_time = clamp(new_value, .5, 10)
