extends Camera2D

var pos1 = Vector2(0 , 0)
var pos2 = Vector2(1152 , 0)

var incrementing = false

var going_to_2 = false
var going_to_1 = false

var increment = 0

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if global_position == pos1 and Input.is_key_pressed(KEY_D):
		going_to_2 = true
		incrementing = true
		
		var tween = create_tween()
		
		tween.tween_property(self , "global_position" , pos2 ,1).set_trans(Tween.TRANS_CIRC)


	if global_position == pos2 and Input.is_key_pressed(KEY_A):
		going_to_1 = true
		incrementing = true
		
		var tween = create_tween()
		
		tween.tween_property(self , "global_position" , pos1 ,1).set_trans(Tween.TRANS_CIRC)
		
		
	if incrementing and going_to_2:
		lerp_colours(Color(0.325, 0.502, 0.831))
		
	if incrementing and going_to_1:
		lerp_colours(Color(0.831 , 0.325 , 0.592))

func lerp_colours(ColorToLerp):
	increment += 0.0012
	
	var colour = $"../TextureRect".modulate
	
	$"../TextureRect".modulate = colour.lerp(ColorToLerp, increment)
	
	if increment >= 0.06:
		incrementing = false
		increment = 0
		
		going_to_1 = false
		going_to_2 = false
	
	
