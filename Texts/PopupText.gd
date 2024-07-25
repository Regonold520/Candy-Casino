extends Node2D


func _make_text(colour , text , object):
	global_position = object.global_position
	$InnerNode/Label.set("theme_override_colors/font_color" , colour)
	$InnerNode/Label.text = text
	
	await get_tree().create_timer(1.5).timeout
	
	queue_free()
