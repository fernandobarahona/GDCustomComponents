tool
extends Node2D

export var arrow_line_texture : Texture setget set_arrow_line_texture_var
export var arrow_pointer_texture : Texture setget set_arrow_pointer_texture_var
export var value : float setget set_value_var
export var arrow_pointer_facing_down :=false setget set_arrow_pointer_facing_down
export var tweened_pointer_movement := false 
export var TWEEN_TIME = 4.2

var _arrow_line_heigth := 0.0
var _arrow_pointer_heigth := 0.0
var _arrow_line_width := 0.0
var _arrow_pointer_width := 0.0

var _pointer_x_position := 0.0
var _pointer_y_position := 0.0

export var max_value := 100.0 setget set_max_value
export var min_value := 0.0 setget set_min_value

func _get_configuration_warning():
	var warning_message = ""
	if arrow_line_texture == null:
		warning_message += "* _selector_line doesn't have a texture\n"
	if arrow_pointer_texture == null:
		warning_message += "* _selector_pointer doesn't have a texture\n"
	return warning_message
	
func _ready():
	set_arrow_line_texture_var(arrow_line_texture)
	set_arrow_pointer_texture_var(arrow_pointer_texture)
	if !Engine.editor_hint:
		_set_arrow_line_sprite_texture()
		_set_arrow_pointer_sprite_texture()
		_set_arrow_pointer_offset()

func set_arrow_pointer_facing_down(facing_down)->void:
	arrow_pointer_facing_down = facing_down
	_set_arrow_pointer_y_offset()
	
func set_value_var(setter_value) -> void:
	value = clamp(setter_value, min_value, max_value)
	_set_arrow_pointer_x_offset()

func set_max_value(setter_max_value):
	max_value = setter_max_value
	_set_arrow_pointer_x_offset()
	
func set_min_value(setter_min_value):
	min_value = setter_min_value
	_set_arrow_pointer_x_offset()

func set_arrow_line_texture_var(line_texture) -> void:
	arrow_line_texture = line_texture

	if Engine.editor_hint:
		_set_arrow_line_sprite_texture()
	else:
		if line_texture == null:
			printerr("_selector_line doesn't have a texture")

func _set_arrow_line_sprite_texture() -> void:
	get_node('%Line').texture = arrow_line_texture
	_get_arrow_line_dimentions()
	_set_arrow_pointer_offset()

	
func _get_arrow_line_dimentions() -> void:
	_arrow_line_heigth = get_node('%Line').texture.get_height() if get_node('%Line').texture else 0
	_arrow_line_width = get_node('%Line').texture.get_width() if get_node('%Line').texture else 0

func set_arrow_pointer_texture_var(pointer_texture) -> void:
	arrow_pointer_texture = pointer_texture
	if Engine.editor_hint:
		_set_arrow_pointer_sprite_texture()
	else:
		if pointer_texture == null:
			printerr("_selector_pointer doesn't have a texture")
		
func _set_arrow_pointer_sprite_texture() -> void:
	get_node('%Pointer').texture = arrow_pointer_texture
	_get_arrow_pointer_dimentions()
	_set_arrow_pointer_offset()

func _get_arrow_pointer_dimentions() -> void:
	_arrow_pointer_heigth = get_node('%Pointer').texture.get_height() if get_node("%Pointer").texture else 0
	_arrow_pointer_width = get_node('%Pointer').texture.get_width() if get_node("%Pointer").texture else 0

func _set_arrow_pointer_offset() -> void:
	_set_arrow_pointer_x_offset()
	_set_arrow_pointer_y_offset()

func _set_arrow_pointer_y_offset() -> void:
	if !arrow_pointer_facing_down:
		_pointer_y_position = int(-(_arrow_line_heigth /2 + _arrow_pointer_heigth / 2)) if arrow_line_texture else 0
		
	else:
		_pointer_y_position = int((_arrow_line_heigth /2 + _arrow_pointer_heigth / 2)) if arrow_line_texture else 0
	get_node('%Pointer').position.y = _pointer_y_position
	
func _set_arrow_pointer_x_offset() -> void:
	
	var min_value_pointer_x_position = - _arrow_line_width/2 + _arrow_pointer_width/2
	var previous_pointer_x_position = _pointer_x_position
	
	_pointer_x_position = min_value_pointer_x_position if value <= min_value else (min_value_pointer_x_position + (_arrow_line_width/max_value * value)) - ((_arrow_pointer_width/max_value) * value)
	
	if arrow_line_texture:
		if tweened_pointer_movement and !Engine.editor_hint:
			get_node("Tween").interpolate_property(
				get_node('Pointer'),
				'position',
				Vector2(previous_pointer_x_position, _pointer_y_position),
				Vector2(_pointer_x_position if value != min_value else min_value_pointer_x_position, _pointer_y_position),
				TWEEN_TIME,
				Tween.TRANS_LINEAR,
				Tween.EASE_OUT
				)
			get_node("Tween").start()
		else:
			get_node('%Pointer').position.x = _pointer_x_position
	else:
		get_node('%Pointer').position.x = 0
