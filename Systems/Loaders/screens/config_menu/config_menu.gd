extends Node2D

var backgrounds_base_url := "res://backgrounds/background_"
var backgrounds := []

var themes = ["theme_1","theme_2","theme_3"]
var buttons

func _ready():
	buttons = [$UseBk1Button, $UseBk2Button, $UseBk3Button]
	for ii in buttons.size():
		assert(buttons[ii].connect("pressed", self, "use_bk", [ii]) == 0)

func use_bk(index):
	var container = $BackgroundContainer
	var instanced_scene_to_go = load(backgrounds_base_url + themes[index] + ".tscn").instance()
	if container.get_child_count() != 0:
		for child in container.get_children():
			child.queue_free()
	container.add_child(instanced_scene_to_go)
