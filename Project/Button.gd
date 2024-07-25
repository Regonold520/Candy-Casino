extends Button

var can_press = true
signal buildmode_toggled

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_pressed():
	if can_press:
		can_press = false
		
		buildmode_toggled.emit()
		GlobalVars.buildmode = !GlobalVars.buildmode
		
		$"../Lines/Line".cycle_runnable = !$"../Lines/Line".cycle_runnable 
		
		$"../Lines/Line"._reroll()
		
		$Timer.start()


func _on_timer_timeout():
	can_press = true


func _on_animation_player_animation_finished(anim_name):
	$Node2D/AnimationPlayer.play(anim_name)


func _on_area_2d_mouse_entered():
	$Node2D/Size.play("Shrink")


func _on_area_2d_mouse_exited():
	$Node2D/Size.play("Grow")