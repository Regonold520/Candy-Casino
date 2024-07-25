extends Node2D

@export var type = "Sour"

@export var popup_colour : Color

@export var money_ammount = 5

var popup_scene = preload("res://Texts/popup_text.tscn")

func _ready():
	await  get_tree().create_timer(0.3).timeout
	
	var popup = popup_scene.instantiate()
	
	get_tree().current_scene.add_child(popup)
	
	popup._make_text(popup_colour, type , self)
