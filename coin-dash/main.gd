extends Node
@export var coin_scene: PackedScene
@export var powerup_scene: PackedScene
@export var cactus_scene: PackedScene
@export var cactus_count: int = 3
@export var playtime = 30
var level = 1
var score = 0
var time_left = 0
var screensize = Vector2.ZERO
var playing = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	screensize = get_viewport().get_visible_rect().size
	$Player.screensize = screensize
	$Player.hide()
	
	#new_game()

func new_game():
	playing = true
	level = 1
	score = 0
	time_left = playtime
	$Player.start()
	$Player.show()
	$GameTimer.start()
	spawn_coins()
	spawn_cactus()
	$HUD.update_score(score)
	$HUD.update_timer(time_left)
	
	
func spawn_coins():
	for i in level + 4:
		var c = coin_scene.instantiate()
		add_child(c)
		c.screensize = screensize
		c.position = Vector2(randi_range(0,screensize.x),
							 randi_range(0, screensize.y))
		
	
func spawn_cactus() -> void:
	for i in cactus_count:
		var cactus = cactus_scene.instantiate()
		add_child(cactus)
		cactus.position = Vector2(randi_range(0, screensize.x), randi_range(0, screensize.y))
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if playing and get_tree().get_nodes_in_group("coins").size() == 0:
		level += 1
		time_left += 5
		spawn_coins()
		reset_powerup_timer()
		
func reset_powerup_timer():
	$PowerUpTimer.start()	




func _on_game_timer_timeout() -> void:
	time_left -= 1
	$HUD.update_timer(time_left)
	if time_left <= 0:
		game_over()


func _on_player_hurt() -> void:
	game_over()


func _on_player_pickup(type) -> void:
	match type:
		"coin":
			$CoinSound.play()
			score += 1
			$HUD.update_score(score)
		"powerup":
			$PowerupSound.play()
			time_left += 5
			$HUD.update_timer(time_left)
			
	#score += 1
	#$HUD.update_score(score)
	#$CoinSound.play()
	
func game_over():
	playing = false
	$GameTimer.stop()
	get_tree().call_group("coins","queue_free")
	$HUD.show_game_over()
	$Player.die()
	$EndSound.play()
	
	
	


func _on_hud_start_game() -> void:
	new_game()


func _on_power_up_timer_timeout() -> void:
	var p = powerup_scene.instantiate()
	add_child(p)
	p.position = Vector2(randi_range(0, screensize.x), randi_range(0, screensize.y)) 
	
