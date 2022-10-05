extends Node

var _registered_containers = []

func _validate_new_container_name(new_container:SceneContainer) -> String:
	var validation_result = ""
	for container in _registered_containers:
		if container._name == new_container.name:
			validation_result += "* Node: "+ str(new_container) + " and other container have the same name. Change one of their names."
	return validation_result

func _register_new_container(new_container:SceneContainer):
	var _err = _validate_new_container_name(new_container)
	assert(_err == "", _err)
	_registered_containers.append(new_container)

func get_container(name:String) -> SceneManager:
	var returned_container = null
	for container in _registered_containers:
		if container.name == name:
			returned_container = container
	assert(returned_container, 'There is no manager with these name: '+ name)
	return returned_container
