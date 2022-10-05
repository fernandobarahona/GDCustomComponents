tool
class_name GoBackButton, "res://global_assets/icons/button_back_icon_16x16_optimized.svg" extends Button

func _ready():
	self.text = "go back"
	self.rect_size = Vector2(400, 135)
	assert(self.connect("pressed",self,"_on_GoBackButton_pressed") == 0)

func _on_GoBackButton_pressed():
	if !Engine.editor_hint:
		SceneManagerSystem.get_container('ScreenContainer').goto_previous_scene()
