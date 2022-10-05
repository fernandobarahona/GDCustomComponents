tool
extends Node2D

signal item_selected(option_id)

const MIN_OPTIONS_VALUE : int = 0

export var selected_option_id: int setget set_selected_option_id

var options_nodes_array: Array
var selected_option_node : TextureButton
var _max__options_value : int

	#validation for number of children and texture of buttons in editor warnings
func _get_configuration_warning():
	return _validate_children_and_textures()
	
func _validate_children_and_textures() -> String:
	var validation_result := ""
	#validation for number of children
	if not(self.get_child_count() > 0):
		validation_result += "* No options (TextureButtons children of: " + self.name + " Node\n"
	else:
		for ii in range (self.get_child_count()):
			if get_child(ii).texture_normal == null:
				validation_result += "* Option No. "+str(ii)+" doesn't have a texture\n"
	return validation_result

func _ready():
	if !Engine.editor_hint:
		if _validate_children_and_textures() != "":
			printerr(_validate_children_and_textures())
		#create options, max value and grafcs
		set_options_node_array()
		set_max_value()
		_edit_options_graphics()
	#connect to detect new children or deleted_children
	if Engine.editor_hint:
		var _err = self.connect("child_entered_tree",self,'_on_children_added')
		var _err2 = self.connect("child_exiting_tree",self,'_on_children_removed')

func _on_children_added(_recived) -> void:
	set_options_node_array()
	set_max_value()
	print(_max__options_value)
	
func _on_children_removed(_recived) -> void:
	yield(_recived, "tree_exited")
	set_options_node_array()
	set_max_value()
	print(_max__options_value)
	
func set_max_value(): 
	_max__options_value = self.get_child_count() - 1

func set_options_node_array():
	options_nodes_array = []
	for ii in range (self.get_child_count()):
		var option = self.get_child(ii)
		options_nodes_array.push_back(option)
		
		if not option.is_connected("pressed", self, "set_selected_option_id"): 
			var _err1 = option.connect("pressed", self, "set_selected_option_id", [ii])

func set_selected_option_id(selected_option_id_from_setter):
	# warning-ignore:narrowing_conversion
	selected_option_id = clamp(selected_option_id_from_setter, MIN_OPTIONS_VALUE, _max__options_value)
#	print(selected_option_id)
	#selected_option_node = self.get_child(selected_option_id)
	#emitir señal
	self.emit_signal("item_selected", selected_option_id, self.name, '')
	#editar grafica de hijo seleccionado
	_edit_options_graphics()
	
func _edit_options_graphics():
	for ii in options_nodes_array.size():
		if ii == selected_option_id:
			options_nodes_array[ii].modulate = Color(1,0,0,1)
		else:
			options_nodes_array[ii].modulate = Color(1,1,1,1)
