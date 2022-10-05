tool
extends Node2D

onready var line : Sprite
onready var pointer : Sprite

export var line_texture : Texture setget set_line_texture
export var pointer_texture : Texture setget set_pointer_texture
export var pointer_x_position : float setget set_pointer_x_position

var _line_width : float = 0
var _line_height : float = 0

var _pointer_width : float = 0
var _pointer_height : float = 0

var _line_position_x : float = 0

func _get_configuration_warning():
	return _validate_textures()
	
func _validate_textures() -> String:
	var validation_result:= ""
	if line_texture == null:
		validation_result += "* _line doesnt have a texture\n"
	if pointer_texture == null:
		validation_result += "* _line doesnt have a texture\n"
	return validation_result

func _ready():

	if !Engine.editor_hint:
		assert(_validate_textures() == "", _validate_textures())

	set_line_texture(line_texture) 
	set_pointer_texture(pointer_texture)
	set_pointer_x_position(pointer_x_position)

func set_line_texture(new_value):
	line_texture = new_value 
	
	if self.is_inside_tree():
		_set_line_node_texture()

		_get_line_dimentions_and_position() 
		
		_update_pointer_y_position()
		_update_pointer_x_position()
	
func _set_line_node_texture():
	$Line.texture = line_texture 

func _get_line_dimentions_and_position():
	if line_texture:
		_line_width = float(line_texture.get_width()) 
		_line_height = float(line_texture.get_height()) 
		_line_position_x = float($Line.global_position.x)
	else: 
		_line_height = 0
		_line_width = 0

func set_pointer_texture(new_value):
	pointer_texture = new_value 
	if self.is_inside_tree():
		_set_pointer_node_texture()
		
		_get_pointer_dimentions()
		_update_pointer_y_position()
	
		_update_pointer_x_position()

func _set_pointer_node_texture():
	$Pointer.texture = pointer_texture
	
func _get_pointer_dimentions():
	if pointer_texture:
		_pointer_width = float(pointer_texture.get_width())
		_pointer_height = float(pointer_texture.get_height())
	else:
		_pointer_width = 0
		_pointer_height = 0

func set_pointer_x_position(new_value: float) -> void:
	pointer_x_position = clamp(new_value, _line_position_x - _line_width / 2 + _pointer_width /2 , _line_position_x + _line_width / 2 - _pointer_width /2) #if line_texture and Engine.editor_hint else new_value
	
	if self.is_inside_tree():
		_update_pointer_x_position()

func _update_pointer_y_position():
	$Pointer.position.y = $Line.position.y - (_line_height/2 + _pointer_height/2) if(line_texture and pointer_texture) else 0.0

func _update_pointer_x_position():
	$Pointer.global_position.x = pointer_x_position#-((_line_width / 2 + _line_position_x) - pointer_x_position) if (line_texture and pointer_texture) else 0.0
