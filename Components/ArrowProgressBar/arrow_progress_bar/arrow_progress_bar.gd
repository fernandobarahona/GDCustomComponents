tool
extends Node2D

export var line_texture : Texture setget set_line_texture
export var pointer_texture : Texture setget set_pointer_texture

export var max_value := 100.0 setget set_max_value
export var min_value := 0.0 setget set_min_value
export var value : float setget set_value

export var arrow_pointer_facing_down :=false setget set_arrow_pointer_facing_down
export var tweened_pointer_movement := false 
export var TWEEN_TIME = 4.2

var _line_heigth := 0.0
var _pointer_heigth := 0.0
var _line_width := 0.0
var _pointer_width := 0.0

var _pointer_x_position := 0.0
var _pointer_y_position := 0.0

func _get_configuration_warning():
	return _validate_textures()

func _validate_textures():
	var validation_result : String = ""
	if line_texture == null:
		validation_result += "* _selector_line doesn't have a texture\n"
	if pointer_texture == null:
		validation_result += "* _selector_pointer doesn't have a texture\n"
	return validation_result
	
func _ready():

	_update_arrow_line_node_texture()
	_update_arrow_pointer_node_texture()
	
	_get_arrow_line_dimentions()
	_get_arrow_pointer_dimentions()
	
	_set_arrow_pointer_offset()

func set_arrow_pointer_facing_down(new_value)->void:
	arrow_pointer_facing_down = new_value
	_set_arrow_pointer_y_offset()
	
func set_value(new_value) -> void:
	value = clamp(new_value, min_value, max_value)
	_set_arrow_pointer_x_offset()

func set_max_value(new_value):
	max_value = new_value
	_set_arrow_pointer_x_offset()
	
func set_min_value(new_value):
	min_value = new_value
	_set_arrow_pointer_x_offset()

func set_line_texture(new_value) -> void:
	line_texture = new_value
	
	if self.is_inside_tree():
		_update_arrow_line_node_texture()
		_get_arrow_line_dimentions()
		_set_arrow_pointer_offset()

func _update_arrow_line_node_texture() -> void:
	$Line.texture = line_texture

func _get_arrow_line_dimentions() -> void:
	_line_heigth = $Line.texture.get_height() if $Line.texture else 0
	_line_width = $Line.texture.get_width() if $Line.texture else 0

func set_pointer_texture(new_value) -> void:
	pointer_texture = new_value

	if self.is_inside_tree():
		_update_arrow_pointer_node_texture()
		_get_arrow_pointer_dimentions()
		_set_arrow_pointer_offset()

func _update_arrow_pointer_node_texture() -> void:
	$Pointer.texture = pointer_texture


func _get_arrow_pointer_dimentions() -> void:
	_pointer_heigth = $Pointer.texture.get_height() if $Pointer.texture else 0
	_pointer_width = $Pointer.texture.get_width() if $Pointer.texture else 0

func _set_arrow_pointer_offset() -> void:
	_set_arrow_pointer_x_offset()
	_set_arrow_pointer_y_offset()

func _set_arrow_pointer_y_offset() -> void:
	if !arrow_pointer_facing_down:
		_pointer_y_position = int(-(_line_heigth /2 + _pointer_heigth / 2)) if line_texture else 0
	else:
		_pointer_y_position = int((_line_heigth /2 + _pointer_heigth / 2)) if line_texture else 0
	$Pointer.position.y = _pointer_y_position
	
func _set_arrow_pointer_x_offset() -> void:
	
	var min_value_pointer_x_position = - _line_width/2 + _pointer_width/2
	var previous_pointer_x_position = _pointer_x_position
	
	_pointer_x_position = min_value_pointer_x_position if value <= min_value else (min_value_pointer_x_position + (_line_width/max_value * value)) - ((_pointer_width/max_value) * value)
	
	if line_texture:
		if tweened_pointer_movement and !Engine.editor_hint:
			$Tween.interpolate_property(
				$Pointer,
				'position',
				Vector2(previous_pointer_x_position, _pointer_y_position),
				Vector2(_pointer_x_position if value != min_value else min_value_pointer_x_position, _pointer_y_position),
				TWEEN_TIME,
				Tween.TRANS_LINEAR,
				Tween.EASE_OUT
				)
			$Tween.start()
		else:
			$Pointer.position.x = _pointer_x_position
	else:
		$Pointer.position.x = 0
