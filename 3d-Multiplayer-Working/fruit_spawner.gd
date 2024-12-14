extends Marker3D

@export var apple_scene = preload("res://Fruit/apple.tscn")
@export var banana_scene = preload("res://Fruit/banana.tscn")
@export var orange_scene = preload("res://Fruit/orange.tscn")
@export var pineapple_scene = preload("res://Fruit/pineapple.tscn")
@export var watermelon_scene = preload("res://Fruit/watermelon.tscn")

var num_of_fruit = 1
var seconds = 5

var rand_x
var rand_y
var rand_z

@onready var timer = $FruitTimer

func _ready():
	timer.wait_time = seconds
	timer.start()

	
func spawn_apple():
	await(get_tree().create_timer(0.1).timeout)
	var apple = apple_scene.instantiate()
	rand_x = randf_range(-20,20)
	rand_y = randf_range(-20,20)
	rand_z = randf_range(-20,20)
	apple.global_position = Vector3(rand_x,rand_y,rand_z)
	add_child(apple)

func spawn_banana():
	await(get_tree().create_timer(0.1).timeout)
	var banana = banana_scene.instantiate()
	rand_x = randf_range(-20,20)
	rand_y = randf_range(-20,20)
	rand_z = randf_range(-20,20)
	banana.global_position = Vector3(rand_x,rand_y,rand_z)
	add_child(banana)
	
func spawn_orange():
	await(get_tree().create_timer(0.1).timeout)
	var orange = orange_scene.instantiate()
	rand_x = randf_range(-20,20)
	rand_y = randf_range(-20,20)
	rand_z = randf_range(-20,20)
	orange.global_position = Vector3(rand_x,rand_y,rand_z)
	add_child(orange)
	
func spawn_pineapple():
	await(get_tree().create_timer(0.1).timeout)
	var pineapple = pineapple_scene.instantiate()
	rand_x = randf_range(-20,20)
	rand_y = randf_range(-20,20)
	rand_z = randf_range(-20,20)
	pineapple.global_position = Vector3(rand_x,rand_y,rand_z)
	add_child(pineapple)
	
func spawn_watermelon():
	await(get_tree().create_timer(0.1).timeout)
	var watermelon = watermelon_scene.instantiate()
	rand_x = randf_range(-20,20)
	rand_y = randf_range(-20,20)
	rand_z = randf_range(-20,20)
	watermelon.global_position = Vector3(rand_x,rand_y,rand_z)
	add_child(watermelon)
	
	
func _on_fruit_timer_timeout() -> void:
	var fruitType = randi_range(1, 20)
	if fruitType > 0 and fruitType <= 7:
		spawn_apple()
	elif fruitType > 8 and fruitType <= 13:
		spawn_orange()
	elif fruitType > 13 and fruitType <= 17:
		spawn_banana()
	elif fruitType > 17 and fruitType <= 19:
		spawn_pineapple()
	elif fruitType == 20:
		spawn_watermelon()
		 
#Comment for commit.
