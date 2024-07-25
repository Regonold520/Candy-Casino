extends Node2D

var menu_scene = preload("res://UI/menu_panel.tscn")
var menu_list = []

var json
var new_dir

func _ready():
	
	var dirs = DirAccess.get_directories_at("res://Conjurors/")
	
	for i in dirs.size():
		new_dir = "res://Conjurors/" + dirs[i] + "/"
		
		json = _parse_json(new_dir + "0_info.json")
		
		var menu = menu_scene.instantiate()
		
		$ScrollContainer/HBoxContainer.add_child(menu)
		
		var sprite = DirAccess.get_files_at(new_dir)
		
		sprite = load(new_dir + sprite[1])
		
		menu.name = dirs[i]
		menu.idx = i
		
		menu.find_child("InnerNode").find_child("ConjSprite").texture = sprite
		menu.find_child("InnerNode").find_child("Cost").text = str(json["cost"])
		menu.find_child("InnerNode").find_child("Name").text = str(json["name"])
		menu.find_child("Owned").text = "Owned: " + str(json["owned"])


func _parse_json(path):
	var file_path : String = path
	
	if FileAccess.file_exists(file_path):
		var data_file = FileAccess.open(file_path, FileAccess.READ)
		var parsed_result = JSON.parse_string(data_file.get_as_text())
		
		if parsed_result is Dictionary:
			return parsed_result

func _save_json(json_path , content):
	var save = JSON.stringify(content , "\t")
	
	var file = FileAccess.open(json_path , FileAccess.WRITE)
	
	file.store_string(save)

func _update_owned_text(menu , value , idx):
	menu.find_child("Owned").text = "Owned: " + str(value)
	print(menu.name)
	$"../Camera2D/CanvasLayer/BuildUI/ScrollContainer/HBoxContainer".get_child(idx).get_child(2).text = "X" + str(value)
