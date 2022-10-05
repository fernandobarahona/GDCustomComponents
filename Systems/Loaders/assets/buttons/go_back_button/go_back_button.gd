extends TextureButton

func _on_GoBackButton_pressed():
	SceneManagerSystem.get_manager('ScreenContainer').goto_previous_scene()
