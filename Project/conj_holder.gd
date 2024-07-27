extends Node2D

var hovering = false
@export var delay = 0.1
var json

var last_conj

func _ready():
	json = _parse_json("res://Conjurors/" + get_child(2).name + "/0_info.json")

func _on_area_2d_mouse_entered():
	hovering = true
	
	if !GlobalVars.buildmode and get_child(2) != null:
		get_child(2).find_child("AnimationPlayer").play("build_hover_in")


func _on_area_2d_mouse_exited():
	hovering = false
	
	if !GlobalVars.buildmode and get_child(2) != null:
		get_child(2).find_child("AnimationPlayer").play("build_hover_out")

func _process(delta):
	if !GlobalVars.buildmode and get_child(2) != null and hovering and Input.is_action_just_pressed("Input"):
		json = _parse_json("res://Conjurors/" + get_child(2).name + "/0_info.json")
		
		last_conj = get_child(2).name
		
		get_child(2).queue_free()
		$"..".max_conjs -= 1
		
		
		var idx = str(last_conj)[0].to_int()
		
		json["owned"] += 1
		
		$"../../../ShopMenu"._save_json("res://Conjurors/" + get_child(2).name + "/0_info.json" , json)
		
		$"../../../ShopMenu"._update_owned_text($"../../../ShopMenu/ScrollContainer/HBoxContainer".get_child(idx) , json["owned"] , idx)
		
	if !GlobalVars.buildmode and get_child(2) == null and hovering and Input.is_action_just_pressed("Input") and GlobalVars.selected_conj != null:
		
		print("skibidi")
		var conj_dir = "res://Conjurors/" + GlobalVars.selected_conj + "/" + DirAccess.get_files_at("res://Conjurors/" + GlobalVars.selected_conj)[3]
		print(conj_dir)
		var conj = load(conj_dir).instantiate()
		add_child(conj)
		
		json = _parse_json("res://Conjurors/" + get_child(2).name + "/0_info.json")
		
		var idx = str(GlobalVars.selected_conj)[0].to_int()
		
		$"..".max_conjs += 1
		
		json["owned"] -= 1
		
		$"../../../ShopMenu"._save_json("res://Conjurors/" + get_child(2).name + "/0_info.json" , json)
		
		$"../../../ShopMenu"._update_owned_text($"../../../ShopMenu/ScrollContainer/HBoxContainer".get_child(idx) , json["owned"] , idx)
		
	else:
		pass


func _parse_json(path):
	var file_path : String = path
	
	if FileAccess.file_exists(file_path):
		var data_file = FileAccess.open(file_path, FileAccess.READ)
		var parsed_result = JSON.parse_string(data_file.get_as_text())
		
		if parsed_result is Dictionary:
			return parsed_result
