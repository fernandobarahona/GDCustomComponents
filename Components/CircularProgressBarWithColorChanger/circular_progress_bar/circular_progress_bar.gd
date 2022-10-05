extends Control

export(int) var value = 15 setget set_value
export(int) var min_value = 0 setget set_min_value
export(int) var max_value = 100 setget set_max_value
export(Color) var ok_color = Color(0,1,0,1)
export(Color) var medium_color = Color(1,1,0,1)
export(Color) var danger_color = Color(1,0,0,1)


func _ready():
	$TextureProgress.step = 0.01
	_set_texture_progress_max_value()
	_set_texture_progress_min_value()
	_set_colors_and_text()

func set_value(new_value):
	if new_value > max_value:
		value = max_value
	elif new_value < min_value:
		value = min_value
	else:
		value = new_value
	if (self.is_inside_tree()):
		_set_colors_and_text()

func _set_colors_and_text():
	var texture_progress_color
	if (range_lerp(value, 0, max_value, 0, 100) < 40):
		texture_progress_color = danger_color
	elif (range_lerp(value, 0, max_value, 0, 100) < 70):
		texture_progress_color = medium_color
	else:
		texture_progress_color = ok_color
	$TextureProgress.tint_progress = texture_progress_color
	$TextureProgress.value = value
	$Label.text = str(ceil(value))

func set_max_value(max_v):
	max_value = max_v
	if (self.is_inside_tree()):
		_set_texture_progress_max_value()

func _set_texture_progress_max_value():
	$TextureProgress.max_value = max_value

func set_min_value(min_v):
	min_value = min_v
	if (self.is_inside_tree()):
		_set_texture_progress_min_value()
		
func _set_texture_progress_min_value():
	$TextureProgress.min_value = min_value
