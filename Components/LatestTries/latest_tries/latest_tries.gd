tool
extends HBoxContainer

export(int) var number_of_tries = 0 setget set_number_of_tries

export(Texture) var new_try_texture = null
export(Texture) var wrong_try_texture = null
export(Texture) var correct_try_texture = null

onready var _last_tries_array := [] 
onready var _last_tries_nodes_array :=[] 

func _get_configuration_warning():
	return _validate_textures()

func _validate_textures() -> String:
	var validation_result = ""
	if new_try_texture == null:
		validation_result += "* new_try_texture has no texture \n"
	if wrong_try_texture == null:
		validation_result += "* wrong_try_texture has no texture \n"
	if correct_try_texture == null:
		validation_result += "* correct_try_texture has no texture \n"	
	return validation_result

func _init():
	if Engine.editor_hint:
		_create_arrays()
		_put_nodes_in_tree()
		
func set_number_of_tries(new_value):
	number_of_tries = new_value
	if Engine.editor_hint:
		_create_arrays()
		_put_nodes_in_tree()

func _ready():
	if !Engine.editor_hint:
		assert(_validate_textures() == "", _validate_textures())
	_create_arrays()
	_put_nodes_in_tree()

func _create_arrays():
	_last_tries_nodes_array = []
	_last_tries_array = []
	for ii in number_of_tries:
		var new_try_node 
		new_try_node = TextureRect.new()
		new_try_node.texture = new_try_texture
		_last_tries_nodes_array.push_front(new_try_node)
		_last_tries_array.push_front(null)

func _put_nodes_in_tree():
	for child in self.get_children():
		child.queue_free()
	for try_node in _last_tries_nodes_array:
		self.add_child(try_node) 

func new_try(is_correct:bool):
	_last_tries_array.pop_front()
	_last_tries_array.push_back(is_correct)
	
	for ii in _last_tries_nodes_array.size():
		if _last_tries_array[ii] == false:
			_last_tries_nodes_array[ii].texture = wrong_try_texture
		elif _last_tries_array[ii] == true:
			_last_tries_nodes_array[ii].texture = correct_try_texture
