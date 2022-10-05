extends Node2D

# warning-ignore:unused_signal
signal backloaded_scenes_changed(scenes, request_id)

var _loader_threads := []

var all_backloaded_scenes = []

func _th_load_scenes(scene_urls):

	var requested_scenes := []
	for scene_url in scene_urls:
		var scene_already_uploaded := false
		for bkloaded_scene in all_backloaded_scenes:
			if bkloaded_scene.resource_path == scene_url: scene_already_uploaded = true
		if !scene_already_uploaded: 
			all_backloaded_scenes.append(load(scene_url))
			requested_scenes.append(load(scene_url))
	call_deferred("emit_signal", "backloaded_scenes_changed", requested_scenes)

func _th_replace_scenes(args):
	var scene_urls = args[0]
	var request_id = args[1]
	all_backloaded_scenes = []
	for scene_url in scene_urls:
		all_backloaded_scenes.append(load(scene_url))
	call_deferred("emit_signal", "backloaded_scenes_changed", all_backloaded_scenes, request_id)

func _th_unload_scenes(args):
	var scene_urls = args[0]
	var request_id = args[1]
	for scene_url in scene_urls:
		for bkloaded_scene in all_backloaded_scenes:
			if bkloaded_scene.resource_path == scene_url: all_backloaded_scenes.erase(bkloaded_scene)
	call_deferred("emit_signal", "backloaded_scenes_changed", all_backloaded_scenes, request_id)

func _th_clear_scenes(args):
	var request_id = args[1]
	all_backloaded_scenes = []
	call_deferred("emit_signal", "backloaded_scenes_changed", all_backloaded_scenes, request_id)

func get_all_backloaded_scenes():
	return all_backloaded_scenes

func replace_scenes(scene_urls: Array):
	return _manage_backloaded_scenes("_th_replace_scenes", scene_urls)

func load_scenes(scene_urls: Array):
	return _manage_backloaded_scenes("_th_load_scenes", scene_urls)

func unload_scenes(scene_urls: Array):
	return _manage_backloaded_scenes("_th_unload_scenes", scene_urls)

func clear_scenes():
	return _manage_backloaded_scenes("_th_clear_scenes", [])

func _manage_backloaded_scenes(_th_function: String, scene_urls: Array):
	for scene_url in scene_urls:
		assert(scene_url is String, "One element of scene urls is not a string")
	
	var loader_thread = Thread.new()
	_loader_threads.append(loader_thread)

	var _err = loader_thread.start(self, _th_function, scene_urls)
	
	var return_value = yield(self, "backloaded_scenes_changed")
	
	for thread in _loader_threads:
		if thread.get_instance_id() == loader_thread.get_instance_id(): 
			thread.wait_to_finish()
			_loader_threads.erase(thread)
	
	return return_value
