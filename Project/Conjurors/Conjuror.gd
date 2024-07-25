extends Node2D

@export var pool = {
	"1": ""
}

@export var pool_size = 1

var random_strength = 30
var shake_fade = 5
var shake_strength = 0

@export var delay = 0

var candy

@export var conj_idx = 0

var produced = false
var triggered = false

var rng = RandomNumberGenerator.new()

# Called when the node enters the scene tree for the first time.
func _ready():
	_roll_candy()

func _roll_candy():
	if $"../..".cycle_runnable:
		await get_tree().create_timer(delay).timeout
		
		var choice = rng.randi_range(1 , pool_size)
		
		var chosen_candy = pool[str(choice)]
		
		var candy_scene = load("res://Candies/Scenes/" + chosen_candy + ".tscn")
		
		candy = candy_scene.instantiate()
		
		add_child(candy)
		
		candy.global_position = $CandySpawn.global_position
		
		_shake(5 , 5)
		
		var tween = create_tween()
		
		tween.tween_property(candy , "global_position" , $CandyEnd.global_position ,0.3).set_trans(Tween.TRANS_CIRC)
		
		await  get_tree().create_timer(0.3).timeout
		
		produced = true


		$"../..".conjs_finished += 1
		$"../..".cycle_types.append(candy.type)
		$"../..".cycle_money += candy.money_ammount

func _process(delta):
	
	if shake_strength > 0:
		shake_strength = lerpf(shake_strength , 0 , shake_fade * delta)
		
		$Sprite2D.position = _shake_ofset()
	
	if !$"../..".cycle and !triggered :
		
		triggered = true
		
		if conj_idx == 1:
			$"../.."._finish_cycle()
			
		
		
		var candy_anim : AnimationPlayer = candy.get_child(1)
	
		candy_anim.play("new_animation")
		
		await get_tree().create_timer(1.5).timeout
		
		var tween = create_tween()
		
		tween.tween_property(candy , "global_position" , $"../../EndPos".global_position ,0.35).set_trans(Tween.TRANS_EXPO)
		
		$"../..".cycle_money += candy.money_ammount
		$"../..".cycle_candies.append(candy)
		

func _shake_ofset() -> Vector2:
	return Vector2(rng.randf_range(-shake_strength , shake_strength) , rng.randf_range(-shake_strength , shake_strength))

func _shake(strength , fade):
	random_strength = strength
	shake_fade = fade
	
	shake_strength = random_strength
