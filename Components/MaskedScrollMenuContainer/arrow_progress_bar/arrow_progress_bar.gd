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

const MAX_VALUE_VAR := 100.0
const MIN_VALUE_VAR := 0.0

func _ready():
	if !Engine.editor_hint:
		_set_arrow_line_sprite_texture()
		_set_arrow_pointer_sprite_texture()
		_set_arrow_pointer_offset()

func set_arrow_pointer_facing_down(facing_down)->void:
	arrow_pointer_facing_down = facing_down
	_set_arrow_pointer_y_offset()
	
func set_value_var(setter_value) -> void:
	if setter_value <= MIN_VALUE_VAR:
		value = MIN_VALUE_VAR
	elif setter_value >= MAX_VALUE_VAR:
		value = MAX_VALUE_VAR
	else:
		value = setter_value
	_set_arrow_pointer_x_offset()
	

func set_arrow_line_texture_var(line_texture) -> void:
	arrow_line_texture = line_texture
	if Engine.editor_hint:
		_set_arrow_line_sprite_texture()
		
func _set_arrow_line_sprite_texture() -> void:
	get_node('%Line').texture = arrow_line_texture
	_get_arrow_line_dimentions()
	_set_arrow_pointer_offset()

	
func _get_arrow_line_dimentions() -> void:
	_arrow_line_heigth = get_node('%Line').texture.get_height() if get_node('%Line').texture else 0
	_arrow_line_width = get_node('%Line').texture.get_width() if get_node('%Line').texture else 0

func set_arrow_pointer_texture_var(pointer) -> void:
	arrow_pointer_texture = pointer
	if Engine.editor_hint:
		_set_arrow_pointer_sprite_texture()
		
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
	
	_pointer_x_position = min_value_pointer_x_position if value <= MIN_VALUE_VAR else (min_value_pointer_x_position + (_arrow_line_width/MAX_VALUE_VAR * value)) - ((_arrow_pointer_width/MAX_VALUE_VAR) * value)
	
	if arrow_line_texture:
		if tweened_pointer_movement and !Engine.editor_hint:
			get_node("Tween").interpolate_property(
				get_node('Pointer'),
				'position',
				Vector2(previous_pointer_x_position, _pointer_y_position),
				Vector2(_pointer_x_position if value != MIN_VALUE_VAR else min_value_pointer_x_position, _pointer_y_position),
				TWEEN_TIME,
				Tween.TRANS_LINEAR,
				Tween.EASE_OUT
				)
			get_node("Tween").start()
		else:
			get_node('%Pointer').position.x = _pointer_x_position
	else:
		get_node('%Pointer').position.x = 0


