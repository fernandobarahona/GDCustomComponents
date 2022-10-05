extends Control

var user_config = UserDataManager.load_user_config()

func _ready():
	print(user_config.score)
	user_config.score = 20
	UserDataManager.save_user_config()
	print(user_config.score)
