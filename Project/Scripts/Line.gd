extends Node2D

var cycle = true
var cycle_runnable = true
var triggered = false

var conjs_finished = 0

signal cycle_finished

@export var max_conjs = 9

var cycle_money = 0
var cycle_candies = []
var cycle_types = []

var random_strength = 30
var shake_fade = 5
var shake_strength = 0

var rng = RandomNumberGenerator.new()


var label_scene : PackedScene = preload("res://Texts/raw_label.tscn")


# Called when the node enters the scene tree for the first time.
func _ready():
	max_conjs = get_child_count() - 2


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	if shake_strength > 0:
		shake_strength = lerpf(shake_strength , 0 , shake_fade * delta)
		
		$EndPos/BoxHolder.position = _shake_ofset()

	if conjs_finished == max_conjs and !triggered:
		cycle = false
		triggered = true
		
func _reroll():
	for i in max_conjs:
		find_child("Conj" + str(i + 1)).get_child(0)._roll_candy()

func _finish_cycle():
	print(cycle_types)
	_check_cycle_types()
	
	await get_tree().create_timer(1.77).timeout
	
	
	
	_shake(15 , 8)
	
	for i in cycle_candies.size():
		cycle_candies[i].queue_free()
		
	for i in max_conjs:
		find_child("Conj" + str(i + 1)).get_child(0)._roll_candy()
		find_child("Conj" + str(i + 1)).get_child(0).triggered = false
		
	cycle_money = roundi(cycle_money)
		
	GlobalVars._add_money(cycle_money , false)
	
	$"AddedText".text = "+" + str(cycle_money)
	
	$"AddedText/AnimationPlayer".play("new_animation")
	
	conjs_finished = 0
	triggered = false
	cycle = true
	cycle_candies = []
	cycle_types = []
	cycle_money = 0
	
	cycle_finished.emit()
	

func _check_cycle_types():
	print(cycle_types)
	_sweet_and_spicy()
	
	_spicy_and_sour()
	
	_sour_and_savory()
	
	_sweet_and_savory()

func _sweet_and_spicy():
	if cycle_types.has("Sweet") and cycle_types.has("Spicy"):
		
		var label = label_scene.instantiate()


		$"../VBoxContainer".add_child(label)
		
		label.get_child(0).get_child(0).text = "Sweet and Spicy flavors dont clash well -35%"
		
		cycle_money *= 0.65
		
		await get_tree().create_timer(2.5).timeout
		
		label.queue_free()
		
func _sour_and_savory():
	if cycle_types.has("Sour") and cycle_types.has("Savory"):
		
		var label = label_scene.instantiate()

		$"../VBoxContainer".add_child(label)
		
		label.get_child(0).get_child(0).text = "Sour and Savory flavors dont clash well -35%"
		
		cycle_money *= 0.65
		
		await get_tree().create_timer(2.5).timeout
		
		label.queue_free()
		
func _spicy_and_sour():
	if cycle_types.has("Sour") and cycle_types.has("Spicy"):
		
		var label = label_scene.instantiate()
		
		$"../VBoxContainer".add_child(label)
		
		label.get_child(0).get_child(0).text = "Sour and Spicy complement each other +25%"
		
		cycle_money *= 1.25
		
		label.get_child(0).get_child(0).set("theme_override_colors/font_color" , Color.SEA_GREEN)
		
		await get_tree().create_timer(2.5).timeout
		
		label.queue_free()
		
func _sweet_and_savory():
	if cycle_types.has("Sweet") and cycle_types.has("Savory"):
		
		var label = label_scene.instantiate()
		
		$"../VBoxContainer".add_child(label)
		
		label.get_child(0).get_child(0).text = "Sweet and Savory complement each other +25%"
		
		cycle_money *= 1.25
		
		label.get_child(0).get_child(0).set("theme_override_colors/font_color" , Color.SEA_GREEN)
		
		await get_tree().create_timer(2.5).timeout
		
		label.queue_free()

func _shake_ofset() -> Vector2:
	return Vector2(rng.randf_range(-shake_strength , shake_strength) , rng.randf_range(-shake_strength , shake_strength))

func _shake(strength , fade):
	random_strength = strength
	shake_fade = fade
	
	shake_strength = random_strength
