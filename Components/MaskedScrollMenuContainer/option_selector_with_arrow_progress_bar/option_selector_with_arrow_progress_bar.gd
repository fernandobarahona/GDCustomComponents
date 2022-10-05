extends Node2D

onready var _progress_arrow_selector =  $ArrowProgressBar
onready var _selector_line = $ArrowProgressBar/Line
onready var _selector_pointer = $ArrowProgressBar/Pointer

onready var _selector_x_position = _progress_arrow_selector.position.x
onready var _selector_line_width = _selector_line.texture.get_width() if _selector_line.texture else 0 
onready var _selector_line_begin = _selector_x_position - _selector_line_width/2

onready var _selector_pointer_width = _selector_pointer.texture.get_width() if _selector_pointer.texture else 0
onready var _min_value_pointer_x_position = _selector_line_begin + (_selector_pointer_width/2) 

func _ready():
	if ((_selector_line_width == 0) or (_selector_pointer_width == 0) or (self.get_child_count() <= 1)): return
	for ii in range (1 , get_child_count()):
		var _option_width = get_child(ii).rect_size.x 
		var _option_x_position = get_child(ii).rect_position.x
		var _option_x_position_rel_to_min_val = (_option_x_position + (_option_width/2)) - _min_value_pointer_x_position
		var corrected_value = (_progress_arrow_selector.MAX_VALUE_VAR * _option_x_position_rel_to_min_val) / (_selector_line_width - _selector_pointer_width) 
		
		
		var _err1 = get_child(ii).connect("pressed", self, "select_option_with_arrow", [corrected_value])


func select_option_with_arrow(corrected_val):
	print(corrected_val)
	_progress_arrow_selector.value = corrected_val


#extends Node2D
#
#onready var progress_arrow_selector =  $ProgressArrowSelector
#onready var selector_line = $ProgressArrowSelector/Line
#onready var option1 = $Sprite
#onready var option2 = $Sprite2
#onready var option3 = $Sprite3
#onready var option4 = $Sprite4
#
#onready var _selector_x_position = progress_arrow_selector.position.x
#onready var _selector_line_width = selector_line.texture.get_width()
#onready var _selector_line_begin = _selector_x_position - _selector_line_width/2
#
#onready var _option1_width = option1.texture.get_width()
#onready var _option1_x_position = option1.position.x

#func _ready():
##	print(get_child_count())
#
#	var exact_option1_position = _option1_x_position - (_selector_line_begin + (_option1_width/2))
#
##	var uncorrected_value = progress_arrow_selector.MAX_VALUE_VAR / ((_selector_line_width - _option1_width) / exact_option1_position)
#
#	var corrected_value = (progress_arrow_selector.MAX_VALUE_VAR * exact_option1_position) / (_selector_line_width - _option1_width)
#
#	progress_arrow_selector.value = corrected_value 
#
#	print(corrected_value)
#
#	print(progress_arrow_selector.value)
