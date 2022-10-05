tool
extends Node2D

signal item_selected(item_id)

const MIN_VALUE : int = 0

export var selected_item_id: int setget set_selected_item_id

var options_nodes_array: Array
var selected_option_node : TextureButton
var _max_value : int

	#validation for number of children and texture of buttons in editor warnings
func _get_configuration_warning():
	return _validate_children_and_textures()
	
func _validate_children_and_textures() -> String:
	var validation_result := ""
	#validation for number of children
	if not(self.get_child_count() > 0):
		validation_result += "* No options (TextureButtons children of " + self.name + ") in options_selector\n"
	else:
		for ii in range (self.get_child_count()):
			if get_child(ii).texture_normal == null:
				validation_result += "* Option No. "+str(get_child(ii).name)+" doesn't have a texture\n"
	return validation_result

func _init():
	_set_options_node_array()
	_set_max_value()
func _ready():
	#connect to detect new children or deleted_children
	if Engine.editor_hint:
		assert(self.connect("child_entered_tree",self,'_on_children_added') == 0)
		if (self.has_signal("child_exiting_tree")):
			assert(self.connect("child_exiting_tree",self,'_on_children_removing') == 0)
		elif (self.has_signal("child_exited_tree")):
			assert(self.connect("child_exiting_tree",self,'_on_children_removing') == 0)

	if !Engine.editor_hint:
		assert(_validate_children_and_textures() == "", _validate_children_and_textures())
	#create options, max value and grafcs
	_set_options_node_array()
	_set_max_value()
	set_selected_item_id(selected_item_id)

func _on_children_added(_recived) -> void:
	_set_options_node_array()
	_set_max_value()
	
func _on_children_removing(_recived) -> void:
	yield(_recived, "tree_exited")
	_set_options_node_array()
	_set_max_value()
	
func _set_max_value():
	_max_value = self.get_child_count() - 1

func _set_options_node_array():
	options_nodes_array = []
	for ii in range (self.get_child_count()):
		var option = self.get_child(ii)
		options_nodes_array.push_back(option)
		
		if not option.is_connected("pressed", self, "set_selected_item_id"): 
			var _err1 = option.connect("pressed", self, "set_selected_item_id", [ii])

func set_selected_item_id(new_value):
	# warning-ignore:narrowing_conversion
	selected_item_id = clamp(new_value, MIN_VALUE, _max_value)
	#emitir señal
	self.emit_signal("item_selected", selected_item_id, self.name)
	#editar grafica de hijo seleccionado
	if options_nodes_array.size():
		options_nodes_array[selected_item_id].grab_focus()
