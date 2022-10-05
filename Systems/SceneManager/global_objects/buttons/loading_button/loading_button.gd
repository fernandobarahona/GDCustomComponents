class_name LoadingButton, "res://global_assets/icons/button_loading_icon_16x16_optimized.svg" extends Button

export var loading := false setget set_loading

var _loading_circular_bar := TextureProgress.new()
var _lcb_texture 
var _lcb_visible_angle = 33

func set_loading_circular_bar_properties():
	_lcb_texture = load(self.get_script().get_path().get_base_dir() + "/texture.png")
	_loading_circular_bar.texture_progress = _lcb_texture
	_loading_circular_bar.fill_mode =  TextureProgress.FILL_CLOCKWISE
	_loading_circular_bar.nine_patch_stretch = true
	_loading_circular_bar.value = _lcb_visible_angle
	_loading_circular_bar.rect_size = Vector2(108, 94)
	_loading_circular_bar.rect_position.x = self.rect_size.x / 2 - _loading_circular_bar.rect_size.x / 2
	print(_loading_circular_bar.rect_position.x)
	_loading_circular_bar.rect_position.y = 0#self.rect_size.y / 2
	self.add_child(_loading_circular_bar)

func _ready():
	set_loading_circular_bar_properties()
	set_loading(loading)

func set_loading(new_value: bool):
	loading = new_value
	if !self.is_inside_tree(): return
	if loading: 
		self.disabled = true
		self.modulate = Color( .5, .5, .5, 1 )
		_loading_circular_bar.visible = true
	else: 
		self.disabled = false
		self.modulate = Color( 1, 1, 1, 1 )
		_loading_circular_bar.visible = false
		
func _process(_delta):
	if !loading : return
	if _loading_circular_bar.radial_initial_angle < 360 + _lcb_visible_angle:
		_loading_circular_bar.radial_initial_angle += 10
	else: _loading_circular_bar.radial_initial_angle = 0
