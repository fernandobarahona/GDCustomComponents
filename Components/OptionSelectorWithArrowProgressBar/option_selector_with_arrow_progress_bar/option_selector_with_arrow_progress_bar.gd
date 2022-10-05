extends Node2D

signal option_btn_selected(option, option_id)

onready var _progress_arrow_selector =  $ArrowProgressBar
onready var _selector_line = $ArrowProgressBar/Line
onready var _selector_pointer = $ArrowProgressBar/Pointer

onready var _selector_x_position = _progress_arrow_selector.position.x
onready var _selector_line_width
onready var _selector_line_begin

onready var _selector_pointer_width
onready var _min_value_pointer_x_position

var options_nodes_array: Array
var options_positions_array : Array
var selected_option_id: int
var selected_option_node : TextureButton

func _ready():
	if not(_selector_line.texture and _selector_pointer and self.get_child_count() > 1):
		printerr("_selector_line or _selector_pointer doesn't have a texture")
		return

	_selector_line_width = _selector_line.texture.get_width()
	_selector_pointer_width = _selector_pointer.texture.get_width()
	_selector_line_begin = _selector_x_position - _selector_line_width/2
	_min_value_pointer_x_position = _selector_line_begin + (_selector_pointer_width/2) 

	for ii in range (1 , self.get_child_count()):
		#crear las opciones
		var _option = self.get_child(ii)
		options_nodes_array.push_back(_option)
		
		var _option_width = _option.rect_size.x 
		var _option_x_position = _option.rect_position.x
		var _option_x_position_rel_to_min_val = (_option_x_position + (_option_width/2)) - _min_value_pointer_x_position
		var _corrected_value = (_progress_arrow_selector.max_value * _option_x_position_rel_to_min_val) / (_selector_line_width - _selector_pointer_width) 
		
		options_positions_array.push_back(_corrected_value)

	for ii in options_nodes_array:
		var _err1 = ii.connect("pressed", self, "select_option_with_arrow", [options_nodes_array[ii.get_index() - 1], options_positions_array[ii.get_index() - 1]])

func select_option_with_arrow(selected_op, sel_option_position):
	#seleccionar
	selected_option_id = selected_op.get_index()
	print(selected_option_id)
	selected_option_node = selected_op
	print(selected_option_node)
	#cambiar value de flecha
	_progress_arrow_selector.value = sel_option_position
	#emitir señal
	self.emit_signal("option_btn_selected", selected_option_node, selected_option_id)
	#editar grafica de hijo seleccionado
	
