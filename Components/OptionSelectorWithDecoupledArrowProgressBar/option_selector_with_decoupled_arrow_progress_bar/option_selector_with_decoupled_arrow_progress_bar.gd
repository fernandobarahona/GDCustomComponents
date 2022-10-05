extends Node2D

signal item_selected(option_id)

onready var showed_number = $NumberLabel

onready var option_selector = self.get_child(0)

onready var _decoupled_arrow_for_option_selector = self.get_child(1)
onready var _selector_pointer = _decoupled_arrow_for_option_selector.get_child(0)
onready var _selector_line = _decoupled_arrow_for_option_selector.get_child(1)

onready var _selector_x_position = _decoupled_arrow_for_option_selector.position.x
onready var _selector_line_width
onready var _selector_line_begin

onready var _selector_pointer_width
onready var _min_value_pointer_x_position

var options_nodes_array: Array
var options_positions_array : Array

export var selected_option_id: int

var selected_option_node : TextureButton
var selected_option_index : int

func _get_configuration_warning():
	return _validate_needed_children()

func _validate_needed_children() -> String:
	var validation_result := ""
	#validation for number of children
	if not(self.get_child_count() == 6):
		validation_result += "* Missing some children or child of: " + self.name + " (1. texture_button_option_selector.tscn, 2. arrow_progress_bar.tscn, 3. PlusTextureBtn, 4. MinusTextureBtn, 5. TextLabel & 6. NumberLabel)\n"
	return validation_result

func _ready():
	if !Engine.editor_hint:
		if _validate_needed_children() != "":
			printerr(_validate_needed_children())
		_set_option_selector_connections()
		_update_showed_label_info()
		_set_arrow_textures_dimentions()
		_fill_options_nodes_array() 
		_fill_options_positions_array()
		_set_options_nodes_array_connections()
	
#	if Engine.editor_hint:
#		var _err = self.connect("child_entered_tree",self,'_on_children_added')
#		var _err2 = self.connect("child_exiting_tree",self,'_on_children_removed')
#
#func _on_children_added(_received) -> void:
#	if _validate_needed_children() != "":
#		printerr(_validate_needed_children())
#
#func _on_children_removed(_received) -> void:
#	if _validate_needed_children() != "":
#		printerr(_validate_needed_children())


func _set_option_selector_connections():
	return	option_selector.connect("item_selected", self, "_on_item_selected")

func _update_showed_label_info():
	showed_number.text = str(option_selector.selected_option_id)

func _on_item_selected(selected_item_index, _parent_selector, _selected_item_object):
	selected_option_index = selected_item_index
	showed_number.text = str(selected_item_index)

func _set_arrow_textures_dimentions():
	_selector_line_width = _selector_line.texture.get_width()
	_selector_pointer_width = _selector_pointer.texture.get_width()
	_selector_line_begin = _selector_x_position - _selector_line_width/2
	_min_value_pointer_x_position = _selector_line_begin + (_selector_pointer_width/2)

func _fill_options_nodes_array():
	for ii in range (0 , option_selector.get_child_count()):
		var _option = option_selector.get_child(ii)
		options_nodes_array.push_back(_option)

func _fill_options_positions_array():
	for _option in options_nodes_array:
		var _option_width = _option.rect_size.x 
		var _option_x_position = _option.rect_position.x
		var _option_x_position_rel_to_min_val = (_option_x_position + (_option_width/2)) - _min_value_pointer_x_position
		var _corrected_value = (_decoupled_arrow_for_option_selector.max_value * _option_x_position_rel_to_min_val) / (_selector_line_width - _selector_pointer_width) 
		
		options_positions_array.push_back(_corrected_value)

func _set_options_nodes_array_connections():
	for ii in options_nodes_array:
		var _err1 = ii.connect("pressed", self, "select_option_with_arrow", [options_nodes_array[ii.get_index()], options_positions_array[ii.get_index()]])

func select_option_with_arrow(selected_op, sel_option_position):
	_decoupled_arrow_for_option_selector.value = sel_option_position
	self.emit_signal("item_selected", selected_op.get_index(), self.name, '')
	
func _on_Plus_pressed():
	option_selector.selected_option_id += 1
	select_option_with_arrow(options_nodes_array[selected_option_index], options_positions_array[selected_option_index])
	
func _on_Minus_pressed():
	option_selector.selected_option_id -= 1
	select_option_with_arrow(options_nodes_array[selected_option_index], options_positions_array[selected_option_index])
