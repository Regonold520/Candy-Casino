extends Control

var panel_scene = load("res://UI/build_panel.tscn")
var selected_idx : int

# Called when the node enters the scene tree for the first time.
func _ready():
	$"../../../Button".buildmode_toggled.connect(_button_pressed)
	
	var dirs = DirAccess.get_directories_at("res://Conjurors/")
	
	for i in dirs.size():
		var current_dir = dirs[i]

		var internal_dirs = DirAccess.get_files_at("res://Conjurors/" + dirs[i] + "/")
		
		var json_path = "res://Conjurors/" + dirs[i] + "/" + internal_dirs[0]
		
		var json = _parse_json(json_path)
		
		var panel = panel_scene.instantiate()
		
		$ScrollContainer/HBoxContainer.add_child(panel)
		
		panel.find_child("Sprite").texture = load("res://Conjurors/" + dirs[i] + "/" + internal_dirs[1])
		panel.find_child("Ammount").text = "X" + str(json["owned"])
		panel.name = dirs[i]
		panel.idx = i


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _button_pressed():
	if GlobalVars.buildmode:
		$AnimationPlayer.play("in")
	else:
		$AnimationPlayer.play("out")

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

func _update_owned_text(menu , value):
	menu.find_child("Owned").text = "Owned: " + str(value)
	
func _reset_selected(idx):
	for i in $ScrollContainer/HBoxContainer.get_child_count():
		$ScrollContainer/HBoxContainer.get_child(i).find_child("BG").visible = false
		
		if i == idx:
			$ScrollContainer/HBoxContainer.get_child(i).find_child("BG").visible = true
