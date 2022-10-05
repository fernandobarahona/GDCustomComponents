extends Button

var backgrounds_base_url := "res://backgrounds/background_"

var config_menus_base_url := "res://screens/config_menu/config_menu_"

var themes = ["theme_1","theme_2","theme_3"]

func _ready():
	var scene_paths_to_load:= []
	var scene_path_to_load: String

	for ii in themes.size():
		var theme = themes[ii]

		scene_path_to_load = backgrounds_base_url + theme + ".tscn"
		scene_paths_to_load.append(scene_path_to_load)
		scene_path_to_load = config_menus_base_url + theme + ".tscn"
		scene_paths_to_load.append(scene_path_to_load)
	ThreadedLoader.load_scenes(scene_paths_to_load)

func _on_GotoConfigButton_pressed():
	assert(get_tree().change_scene("res://screens/config_menu/config_menu.tscn") == 0)
