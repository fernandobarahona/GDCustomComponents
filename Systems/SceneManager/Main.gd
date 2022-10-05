extends Node2D

func _ready():
	
	var initial_screen = load("res://screens/main_menu/main_menu_"+UserConfig.theme+".tscn")
	var initial_background = load("res://backgrounds/background_"+UserConfig.theme+".tscn")

	SceneManagerSystem.get_container("BackgroundContainer").goto_scene_without_history(initial_background)
	SceneManagerSystem.get_container("ScreenContainer").goto_scene(initial_screen)
