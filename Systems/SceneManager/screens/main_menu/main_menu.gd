extends Control

onready var sub_menu_A = load("res://screens/sub_menu_a/sub_menu_a_"+UserConfig.theme+".tscn")
onready var sub_menu_B = load("res://screens/sub_menu_b/sub_menu_b_"+UserConfig.theme+".tscn")
onready var config_menu = load("res://screens/config_menu/config_menu_"+UserConfig.theme+".tscn")

func _on_SubMenuAButton_pressed():
	SceneManagerSystem.get_container('ScreenContainer').goto_scene(sub_menu_A)
	
func _on_SubMenuBButton_pressed():
	SceneManagerSystem.get_container('ScreenContainer').goto_scene(sub_menu_B)

func _on_GotoConfigButton_pressed():
	SceneManagerSystem.get_container('ScreenContainer').goto_scene(config_menu)
