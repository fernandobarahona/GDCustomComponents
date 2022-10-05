tool
extends Node2D

export var line_texture : Texture setget set_line_texture
export var pointer_texture : Texture setget set_pointer_texture
export var number_of_items := 2 setget set_number_of_items
export var selected_item_position := 1 setget	set_selected_item_position
export var arrow_pointer_facing_down :=false setget set_arrow_pointer_facing_down
export var tweened_pointer_movement := false 
export var TWEEN_TIME = 0.2

var _arrow_line_heigth := 0.0
var _arrow_pointer_heigth := 0.0
var _arrow_line_width := 0.0
var _arrow_pointer_width := 0.0

var _pointer_x_position := 0.0
var _pointer_y_position := 0.0

const MINIMUN_NUMBER_OF_ITEMS = 2
const MAXIMUN_NUMBER_OF_ITEMS = 10

func _ready():
	_update_line_node_texture()
	_update_pointer_node_texture()
	_get_line_dimentions()
	_get_pointer_dimentions()
	_set_pointer_offset()

func set_arrow_pointer_facing_down(new_value)->void:
	arrow_pointer_facing_down = new_value
	_set_pointer_y_offset()
	
func set_number_of_items(new_value: int) -> void:
	number_of_items = clamp(new_value, MINIMUN_NUMBER_OF_ITEMS, MAXIMUN_NUMBER_OF_ITEMS)

	if number_of_items < selected_item_position:
		self.selected_item_position = number_of_items

	_set_pointer_x_offset()

func set_selected_item_position(new_value) -> void:
	selected_item_position = clamp(new_value, 1, number_of_items)
	_set_pointer_x_offset()

func set_line_texture(new_value) -> void:
	line_texture = new_value
	if self.is_inside_tree():
		_update_line_node_texture()
		_get_line_dimentions()
		_set_pointer_offset()
		
func _update_line_node_texture() -> void:
	$Line.texture = line_texture
	
func _get_line_dimentions() -> void:
	_arrow_line_heigth = $Line.texture.get_height() if $Line.texture else 0
	_arrow_line_width = $Line.texture.get_width() if $Line.texture else 0

func set_pointer_texture(new_value) -> void:
	pointer_texture = new_value
	if self.is_inside_tree():
		_update_pointer_node_texture()
		_get_pointer_dimentions()
		_set_pointer_offset()

func _update_pointer_node_texture() -> void:
	$Pointer.texture = pointer_texture

func _get_pointer_dimentions() -> void:
	_arrow_pointer_heigth = $Pointer.texture.get_height() if $Pointer.texture else 0
	_arrow_pointer_width = $Pointer.texture.get_width() if $Pointer.texture else 0

func _set_pointer_offset() -> void:
	_set_pointer_y_offset()
	_set_pointer_x_offset()

func _set_pointer_y_offset() -> void:
	if !arrow_pointer_facing_down:
		_pointer_y_position = int(-(_arrow_line_heigth /2 + _arrow_pointer_heigth / 2)) if line_texture else 0
	else:
		_pointer_y_position = int((_arrow_line_heigth /2 + _arrow_pointer_heigth / 2)) if line_texture else 0
	$Pointer.position.y = _pointer_y_position

	
func _set_pointer_x_offset() -> void:
	var previous_pointer_x_position = _pointer_x_position
	
	_pointer_x_position = int(-(_arrow_line_width / 2 - _arrow_pointer_width / 2) + (((_arrow_line_width - _arrow_pointer_width) / (number_of_items - 1)) * (selected_item_position - 1)))

	if line_texture:
		if tweened_pointer_movement and !Engine.editor_hint:
			$Tween.interpolate_property(
				$Pointer,
				'position',
				Vector2(previous_pointer_x_position, _pointer_y_position),
				Vector2(_pointer_x_position , _pointer_y_position),
				TWEEN_TIME,
				Tween.TRANS_LINEAR,
				Tween.EASE_OUT
				)
			$Tween.start()
		else:
			$Pointer.position.x = _pointer_x_position
	else:
		$Pointer.position.x = 0
