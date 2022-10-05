extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	var stylebox = load("res://assets/new_styleboxflat.tres")
	var scroller = $ScrollContainer.get_v_scrollbar()
	scroller.size_flags_vertical = 8
	scroller.rect_position.y = 20
	scroller.margin_top = 20
	scroller.rect_scale.y = .8
	printt(scroller.rect_size.y, scroller.rect_min_size.y, scroller.rect_scale.y)
	scroller.add_stylebox_override("scroll", stylebox)
	
	assert($VScrollBar.connect("value_changed", self, "_on_value_changed") == 0)

func _on_value_changed(_value):
	print(_value)

