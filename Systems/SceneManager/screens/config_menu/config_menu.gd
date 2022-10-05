extends Control

var backgrounds_base_url := "res://backgrounds/background_"

var config_menus_base_url := "res://screens/config_menu/config_menu_"

var themes = ["theme_1","theme_2","theme_3"]

onready var theme_buttons = {
	"theme_1": $GotoTheme1Button, 
	"theme_2": $GotoTheme2Button, 
	"theme_3": $GotoTheme3Button
	}

func _ready():
	$SpeedValue.text = str(UserConfig.sprite_effect_time)
	load_theme_button_scenes()

func load_theme_button_scenes():
	for theme in themes:
		if !(theme == UserConfig.theme): theme_buttons[theme].loading = true
		assert(theme_buttons[theme].connect("pressed", self, "_select_theme", [theme]) == 0)
	
	for theme in themes:
		var scene_paths_to_load:= []
		var scene_path_to_load: String

		scene_path_to_load = backgrounds_base_url + theme + ".tscn"
		scene_paths_to_load.append(scene_path_to_load)

		scene_path_to_load = config_menus_base_url + theme + ".tscn"
		scene_paths_to_load.append(scene_path_to_load)

		yield(SceneManagerSystem.get_container("ScreenContainer").returned_async_load(scene_paths_to_load), "completed")

		theme_buttons[theme].loading = false

func _select_theme(selected_theme: String):
	UserConfig.theme = selected_theme

	SceneManagerSystem.get_container("BackgroundContainer").goto_scene_without_history(load("res://backgrounds/background_"+UserConfig.theme+".tscn"))
	SceneManagerSystem.get_container("ScreenContainer").update_theme(selected_theme)

func _on_GoBackButton_pressed():
	yield(SceneManagerSystem.get_container("ScreenContainer").clear_loaded_scenes(), "completed")
	SceneManagerSystem.get_container('ScreenContainer').goto_previous_scene()

func _change_speed_value(is_incrementing := true):
	if is_incrementing:
		UserConfig.sprite_effect_time += .5
	else:
		UserConfig.sprite_effect_time -= .5
	$SpeedValue.text = str(UserConfig.sprite_effect_time)
