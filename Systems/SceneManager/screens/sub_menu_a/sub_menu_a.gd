extends Control

onready var game = load("res://screens/game/game_"+UserConfig.theme+".tscn")

func _on_GoToGameButton_pressed():
	SceneManagerSystem.get_container('ScreenContainer').goto_scene(game)
