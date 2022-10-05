class_name Game extends Control

var _NORMAL_COLOR = Color( 1, 1, 0, 1 )
var _MODULATED_COLOR = Color( 1, 0, 1, 1 )
var _is_modulated := false

onready var config_menu = load("res://screens/config_menu/config_menu_"+UserConfig.theme+".tscn")

func _ready():
	_change_sprite_color()
	$Timer.wait_time = UserConfig.sprite_effect_time
	$CircularCountDown._set_total_time(UserConfig.sprite_effect_time)
	assert($Timer.connect("timeout", self, "_change_sprite_color") == 0)

func _change_sprite_color():
	$Timer.wait_time = UserConfig.sprite_effect_time
	$CircularCountDown._set_total_time(UserConfig.sprite_effect_time)
	if _is_modulated:
		$Sprite.modulate = _MODULATED_COLOR
	else:
		$Sprite.modulate = _NORMAL_COLOR
	_is_modulated = !_is_modulated

func _on_GotoConfigButton_pressed():
	SceneManagerSystem.get_container('ScreenContainer').goto_scene(config_menu)
