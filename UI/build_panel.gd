extends Control

var hovering = false
var idx 

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if hovering and Input.is_action_just_pressed("Input"):
		print(idx)
		get_parent().get_parent().get_parent()._reset_selected(idx)


func _on_area_2d_mouse_entered():
	hovering = true

func _on_area_2d_mouse_exited():
	hovering = false
