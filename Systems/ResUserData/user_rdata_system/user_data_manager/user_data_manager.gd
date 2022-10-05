extends Node

const udata_base_url = "res://data/user_data_system/"

var user_config:UserConfig

func save_user_config():
	var directory_manager = Directory.new()
	if !directory_manager.dir_exists(udata_base_url): 
		directory_manager.make_dir_recursive(udata_base_url)
	var _err = ResourceSaver.save(udata_base_url + "user_rdata.tres", user_config)

func load_user_config() -> UserConfig:
	var file_name = udata_base_url + "user_rdata.tres"
	user_config = UserConfig.new()

	if ResourceLoader.exists(file_name):
		var user_data = ResourceLoader.load(file_name)
		if user_data is UserConfig: # Check that the data is valid
			user_config = user_data

	return user_config
