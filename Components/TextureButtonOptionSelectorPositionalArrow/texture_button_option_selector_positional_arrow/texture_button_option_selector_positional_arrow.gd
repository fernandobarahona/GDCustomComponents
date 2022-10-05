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
	_set_options_node_array()
	_set_max_value()
	return _validate_children_and_textures()
	
func _validate_children_and_textures() -> String:
	var validation_result := ""
	#validation for number of children
	
	if options_nodes_array.size() == 0:
		validation_result += "* No options (TextureButtons children of " + self.name + ") in options_selector\n"
	else:
		for option in options_nodes_array:
			if option.texture_normal == null:
				validation_result += "* Option No. " + str(option.name) + " doesn't have a texture\n"
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

	_set_options_node_array()
	_set_max_value()
	set_selected_item_id(selected_item_id)

	if !Engine.editor_hint and self.is_inside_tree():
		assert(_validate_children_and_textures() == "", _validate_children_and_textures())

func _on_children_added(_recived) -> void:
	_set_options_node_array()
	_set_max_value()
	
func _on_children_removing(_recived) -> void:
	yield(_recived, "tree_exited")
	_set_options_node_array()
	_set_max_value()
	
func _set_max_value():
	_max_value = self.get_child_count() - 2

func _set_options_node_array():
	options_nodes_array = []

	for ii in range (self.get_child_count()):
		var option = self.get_child(ii)
		if option.name != 'PositionalArrow':
			options_nodes_array.push_back(option)

	for ii in options_nodes_array.size():
		if not options_nodes_array[ii].is_connected("pressed", self, "set_selected_item_id"): 
			var _err1 = options_nodes_array[ii].connect("pressed", self, "set_selected_item_id", [ii])

func set_selected_item_id(new_value):
	# warning-ignore:narrowing_conversion
	selected_item_id = clamp(new_value, MIN_VALUE, _max_value)
	#emitir señal
	if self.is_inside_tree():
		self.emit_signal("item_selected", selected_item_id, self.name)
		#editar grafica de hijo seleccionado
		var selected_node:TextureButton = options_nodes_array[selected_item_id]
		
		selected_node.grab_focus()
		#mover el puntero de PositionaArrow
		$PositionalArrow.pointer_x_position = selected_node.rect_position.x + selected_node.rect_size.x / 2
