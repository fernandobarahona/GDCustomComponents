class_name SceneManager extends Node

var _async_loader = AsyncLoader.new()
var _container
var _name: String

var _current_packed_scene : PackedScene
var _current_instanced_scene: Node
var _previous_packed_scene: PackedScene
var _scene_history : Array

var _theme

func _ready():
	if !Engine.editor_hint:
		_theme = UserConfig.theme
#FUNCTIONS FOR CHANGING NODES

func goto_scene_without_history(packed_scene_to_go: PackedScene):
	if _container.get_child_count() != 0 and packed_scene_to_go.resource_path == _container.get_child(0).filename: return
	
	_current_instanced_scene = packed_scene_to_go.instance()

	_change_scene(_current_instanced_scene)

func _change_scene(instanced_scene_to_go: Node):
	#Erase previous_scene_nodes from tree and memory
	if _container.get_child_count() != 0:
		for child in _container.get_children():
			child.queue_free()

	#instanciate the new scene and add it to the tree
	_container.add_child(instanced_scene_to_go)

#FUNCTIONS FOR HISTORY

func goto_scene(packed_scene_to_go: PackedScene):
	if packed_scene_to_go == _current_packed_scene: return

	if _current_packed_scene: 
		_scene_history.push_back(_current_packed_scene.resource_path.trim_suffix(_theme + ".tscn"))
		_previous_packed_scene = _current_packed_scene
	
	_current_packed_scene = packed_scene_to_go
	_current_instanced_scene = _current_packed_scene.instance()

	_change_scene(_current_instanced_scene)

func goto_previous_scene():
	if !_previous_packed_scene : return

	_change_scene(_previous_packed_scene.instance())

	_current_packed_scene = _previous_packed_scene
	
	_scene_history.pop_back()
	_previous_packed_scene = load(_scene_history[_scene_history.size() - 1] + _theme + ".tscn") if _scene_history.size() > 0 else null

#FUNCTIONS FOR HISTORY WITH THEMES

func update_theme(new_theme: String):
	if _previous_packed_scene:
		_previous_packed_scene = load(_previous_packed_scene.resource_path.trim_suffix(_theme + ".tscn") + new_theme + ".tscn" )
	if _current_packed_scene:
		_current_packed_scene = load(_current_packed_scene.resource_path.trim_suffix(_theme + ".tscn") + new_theme + ".tscn" )
		_current_instanced_scene = _current_packed_scene.instance()

	self._change_scene(_current_instanced_scene)

	_theme = new_theme

#FUNCTIONS FOR ACCESING 
func get_loaded_scenes() -> Array:
	return _async_loader.get_all_backloaded_scenes()

func get_async_loader() -> AsyncLoader:
	return _async_loader

#FUNCTIONS FOR THREADED LOADING
func async_load(scene_urls: Array):
	_async_loader.load_scenes(scene_urls)

func returned_async_load(scene_urls: Array):
	var returned_value = yield(_async_loader.load_scenes(scene_urls), "completed")
	return returned_value

func clear_loaded_scenes():
	var returned_value = yield(_async_loader.clear_scenes(), "completed")
	return returned_value
