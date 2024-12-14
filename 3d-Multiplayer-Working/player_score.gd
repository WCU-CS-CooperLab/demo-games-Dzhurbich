extends Control

@onready var player_1_label = $P1Score
@onready var player_2_label = $P2Score
@onready var player_3_label = $P3Score
@onready var player_4_label = $P4Score

var round_time: int = 45

#var player_1_score = 0
#var player_2_score = 0
var seconds = 0
#var goal = 10
var game_over = false
var total_rounds = 3
var current_round = 1 
var round_wins = [0, 0, 0, 0]

func reset_fruit_kills():
	SetPlayers.player_1_score = 0
	SetPlayers.player_2_score = 0
	SetPlayers.player_3_score = 0
	SetPlayers.player_4_score = 0
	player_1_label.text = "P1: 0"
	player_2_label.text = "P2: 0"
	player_3_label.text = "P3: 0"
	player_4_label.text = "P4: 0"
	print("Fruit kills reset for the new round.")

@onready var player_winner_label = $WinnerLabel
@onready var label = $ScrollContainer/Label
@onready var line_edit = $LineEdit
@onready var container = $ScrollContainer
@onready var timer_label = $TimerLabel



func _ready():
	start_timer()
	var round_winner_scene = $RoundWinner
	if round_winner_scene == null:
		round_winner_scene = preload("res://RoundWinner.tscn").instantiate()
		add_child(round_winner_scene)
		round_winner_scene.hide()
	round_winner_scene.connect("reset_timer", Callable(self, "rest_and_start_timer"))
	
	# This connects the player_shooting global to the function "_on_player_shooting" which is located below in the script.
	SetPlayers.connect("set_fruit", Callable(self, "get_info"))
	if(multiplayer.get_peers().size() == 2):
		player_1_label.show()
		player_2_label.show()
	elif(multiplayer.get_peers().size() == 3):
		player_1_label.show()
		player_2_label.show()
		player_3_label.show()
	elif(multiplayer.get_peers().size() == 4):
		player_1_label.show()
		player_2_label.show()
		player_3_label.show()
		player_4_label.show()

func start_timer():
	round_time = 45
	timer_label.text = "Time Left: %d" % round_time
	$GameTimer.start(1)
	

@rpc("any_peer", "call_local", "reliable", 2)
func add_score(shooter_name, score):
	if game_over:
		return

	var peer_id = multiplayer.get_remote_sender_id()

	if shooter_name == "P1":
		player_1_label.text = str(score)
	elif shooter_name == "P2":
		player_2_label.text = str(score)
	elif shooter_name == "P3":
		player_3_label.text = str(score)
	elif shooter_name == "P4":
		player_4_label.text = str(score)

	
#	if int(player_1_label.text) == goal:
		#rpc("declare_winner", "Player 1")
	#elif int(player_2_label.text) == goal:
		#rpc("declare_winner", "Player 2")
	#elif int(player_3_label.text) == goal:
		#rpc("declare_winner", "Player 3")
	#elif int(player_4_label.text) == goal:
		#rpc("declare_winner", "Player 4")


@rpc("any_peer", "call_local", "reliable", 2)
func declare_winner(winner_name):
	if game_over:
		return
	
	game_over = true
	#player_winner_label.text = "%s has won!" % winner_name
	#player_winner_label.show()
	#$Restart.show()

	rpc("lock_game")
	

@rpc("any_peer", "call_local", "reliable", 2)
func lock_game():
	game_over = true





#func _on_restart_pressed() -> void:
	# Right now I am having trouble with resetting the game. I tried using a similar approach with global, and was having trouble.
	#print("Restart Button Pressed")
	#SetPlayers.restart.emit(multiplayer.get_unique_id())

func get_info(shooter_name, fruit_type):
	print(shooter_name)
	print(fruit_type)
	
	if game_over:
		return
		
	print("PLAYER SCORE SHOOTER NAME DISPLAY" + shooter_name)

	# Update the shooter's score based on their name
	if shooter_name == "P1":
		print("Player 1 Scored!")
		SetPlayers.player_1_score += 1
		rpc("add_score", shooter_name, SetPlayers.player_1_score)
	elif shooter_name == "P2":
		print("Player 2 Scored!")
		SetPlayers.player_2_score += 1
		rpc("add_score", shooter_name, SetPlayers.player_2_score)
	elif shooter_name == "P3":
		print("Player 3 Scored!")
		SetPlayers.player_3_score += 1
		rpc("add_score", shooter_name, SetPlayers.player_3_score)
	elif shooter_name == "P4":
		print("Player 4 Scored!")
		SetPlayers.player_4_score += 1
		rpc("add_score", shooter_name, SetPlayers.player_4_score)

func change_timer():
	seconds += 1
	var hours   = int(seconds / 3600)
	var minutes = int((seconds % 3600) / 60)
	var seconds = int(seconds % 60)
	
	$TimerLabel.text = str(hours) + ":" + str(minutes) + ":" + str(seconds)


func _on_game_timer_timeout() -> void:
	print("Current round_timer: ", round_time)
	if round_time > 0:
		round_time -= 1
		timer_label.text = "Time Left: %d" % round_time
	else:
		$GameTimer.stop()
		end_round()

func end_round():
	# get player scores
	var scores = [SetPlayers.player_1_score, SetPlayers.player_2_score, SetPlayers.player_3_score, SetPlayers.player_4_score]
	
	#find the maxim score and identify the winners 
	var max_score = scores.max()
	var winners = []
	for i in range(scores.size()):
		if scores[i] == max_score:
			winners.append(i)
	for winner in winners:
		round_wins[winner] += 1
		
		# Check if all rounds are completed
	if current_round >= total_rounds:
		declare_overall_winner()
	else:
		current_round += 1
		reset_round_state()
		reset_fruit_kills()
		reset_and_start_timer()
		
	#load the round winner scene
	var round_winner_scene = preload("res://RoundWinner.tscn").instantiate()
	get_tree().root.add_child(round_winner_scene)
	#emit_signal("end_round", scores, winners)
	
	#update the round winner scene with scores and winners 
	#pass scores and winners to the RoundWinner Scene
	round_winner_scene.display_winner(scores, winners)
	
	

	
func update_hud():
	player_1_label.text = "P1: %d kills | %d wins" % [SetPlayers.player_1_score, round_wins[0]]
	player_2_label.text = "P2: %d kills | %d wins" % [SetPlayers.player_2_score, round_wins[1]]
	player_3_label.text = "P3: %d kills | %d wins" % [SetPlayers.player_3_score, round_wins[2]]
	player_4_label.text = "P4: %d kills | %d wins" % [SetPlayers.player_4_score, round_wins[3]]

func reset_round_state():
	round_time = 45
	timer_label.text = "Time Left: %d" % round_time
	print("Round state reset")


func reset_and_start_timer():
	round_time = 45  # Reset the timer value
	$TimerLabel.text = "Time Left: %d" % round_time
	$GameTimer.start()  # Start the timer
	print("Timer has been reset and started.")
	
	
func declare_overall_winner():
	var max_wins = round_wins.max()
	var winners = []
	for i in range(round_wins.size()):
		if round_wins[i] == max_wins:
			winners.append(i)	
			
	# Pass the final winner to RoundWinner.gd (optional)
	var round_winner_scene = preload("res://RoundWinner.tscn").instantiate()
	get_tree().root.add_child(round_winner_scene)
	round_winner_scene.display_final_winner(winners)

	# Stop the game and display the final winner
	$GameTimer.stop()
	print("Game Over!")		
			
			
