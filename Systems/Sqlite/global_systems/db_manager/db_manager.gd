extends Node

const SQLite = preload("res://addons/godot-sqlite/bin/gdsqlite.gdns")
var db : SQLite
var db_folder_path = "user://data_store/"
var db_file_name = "database.db"
var table_name = "UserInfo"
var dir_manager = Directory.new()

func _ready():
	pass

func commit_data_to_db(new_user_name: String, new_user_score: String):
	
	var new_user := Dictionary()
	
	if !dir_manager.dir_exists(db_folder_path):
		dir_manager.make_dir(db_folder_path)

	db = SQLite.new()
	db.path = db_file_name
	db.open_db()

	new_user["Name"] = new_user_name
	new_user["Score"] = new_user_score

	db.create_table()
	db.insert_row(table_name, new_user)

func read_data_from_db():
	db = SQLite.new()
	db.path = db_file_name
	db.open_db()
	
	var table_name = "UserInfo"
	db.query("select * from " + table_name+ ";")
	for ii in range(0, db.query_result.size()):
		print("User: ", db.query_result[ii]["Name"], " has ", db.query_result[ii]["Score"], "points.")
