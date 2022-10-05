tool
class_name SceneContainer extends SceneManager

export(String) var autoload_name = "SceneManagerSystem"

func _get_configuration_warning():
	var validation_result = ""
	if self.name == "SceneContainer":
		validation_result += "* SceneContainer is the generic name for this Scene. If you instantiated more than once make sure they don't have the same name. It would cause a crash when instantiated at runtime.\n   Consider changing the name of the node of instantiated scene."
	return validation_result

func _validate_autoload() -> String:
	var validation_result = ""
	if !$"/root".has_node(autoload_name):
		validation_result += "* SceneManagerSystem hasn't been set to an Autoload. Add it on ProjectSettings/Autoload.\nIf you change its name, define it in this node autoload_name."
	return validation_result

func _init():
	_container = self
	_name = self.name

func _ready():
	if !Engine.editor_hint:
		_register_in_system()

func _register_in_system():
	get_node("/root/"+autoload_name)._register_new_container(self)
