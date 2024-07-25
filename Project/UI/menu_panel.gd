extends Control

var is_hovering = false
var idx

func _process(delta):

	if Input.is_action_just_pressed("Input") and is_hovering:
		var json = _parse_json("res://Conjurors/" + name + "/0_info.json")
		
		
		if GlobalVars._can_buy(json["cost"]):
			
			json["owned"] += 1
			get_parent().get_parent().get_parent()._update_owned_text(self , json["owned"] , idx)
			
			get_parent().get_parent().get_parent()._save_json("res://Conjurors/" + name + "/0_info.json" , json)
			
			GlobalVars._add_money(json["cost"] , true)

func _on_area_2d_mouse_entered():
	is_hovering = true
	$AnimationPlayer.play("hover_in")

func _on_area_2d_mouse_exited():
	is_hovering = false
	$AnimationPlayer.play("hover_out")

func _parse_json(path):
	var file_path : String = path
	
	if FileAccess.file_exists(file_path):
		var data_file = FileAccess.open(file_path, FileAccess.READ)
		var parsed_result = JSON.parse_string(data_file.get_as_text())
		
		if parsed_result is Dictionary:
			return parsed_result
