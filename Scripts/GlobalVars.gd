extends Node

var buildmode = true

func _ready():
	var json = _parse_json("res://Jsons/SaveData.json")
	
	get_tree().current_scene.find_child("Camera2D").get_child(0).get_child(0).text = str(json["money"])

func _add_money(ammount , minus):
	var json = _parse_json("res://Jsons/SaveData.json")
	
	if !minus:
		json["money"] += ammount
	if minus:
		json["money"] -= ammount
	GlobalVars._save_json("res://Jsons/SaveData.json" , json)
	
	get_tree().current_scene.find_child("Camera2D").get_child(0).get_child(0).text = str(json["money"])

func _save_json(json_path , content):
	var save = JSON.stringify(content , "\t")
	
	var file = FileAccess.open(json_path , FileAccess.WRITE)
	
	file.store_string(save)
	
func _parse_json(path):
	var file_path : String = path
	
	if FileAccess.file_exists(file_path):
		var data_file = FileAccess.open(file_path, FileAccess.READ)
		var parsed_result = JSON.parse_string(data_file.get_as_text())
		
		if parsed_result is Dictionary:
			return parsed_result

func _can_buy(ammount):
	var json = _parse_json("res://Jsons/SaveData.json")
	
	return json["money"] >= ammount
