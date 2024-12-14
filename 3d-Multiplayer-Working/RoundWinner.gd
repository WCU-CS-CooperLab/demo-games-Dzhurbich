extends Control

signal next_round
signal reset_timer
signal next_round_started
signal start_time

@onready var player_1_label = $VBoxContainer/Player1Score
@onready var player_2_label = $VBoxContainer/Player2Score
@onready var player_3_label = $VBoxContainer/Player3Score
@onready var player_4_label = $VBoxContainer/Player4Score
@onready var winner_label = $WinnerLabel
@onready var next_round_button = $Button
@onready var game_timer = $GameTimer
@onready var timerLabel = $TimerLabel

# Keep track of points for each player
var points = [0, 0, 0, 0]  # Index corresponds to Player 1, Player 2, etc.
var round_time = 45
var current_round = 1
var max_rounds = 3
# Function to update points and display the winner 
func display_winner(scores: Array, winner_indices: Array):
	# Update the points for the round winners 
	for index in winner_indices:
		points[index] += 1
		
	# Update score labels for all players 
	player_1_label.text = "Player 1: %d" % points[0]
	player_2_label.text = "Player 2: %d" % points[1]
	player_3_label.text = "Player 3: %d" % points[2]
	player_4_label.text = "Player 4: %d" % points[3]
	
	# Display the winner
	if winner_indices.size() == 1:
		winner_label.text = "Winner: Player %d" % (winner_indices[0] + 1)
	else:
		var winner_names = []
		for i in winner_indices:
			winner_names.append("Player %d" % (i + 1))
		#var winner_text = ", ".join(winner_names)
		winner_label.text = "Winners: %s" % " , ".join(winner_names)

# Function to reset the round state
func reset_round_state():
	# Reset any variables specific to the round
	round_time = 45
	#$GameTimer.stop()
	#$GameTimer.start()
	print("Resetting the round state...")
	emit_signal("start_timer")

# Function to start a new round
func start_new_round():
	# Logic to start a new round
	print("Starting a new round...")
	#round_time = 45
	#$GameTimer.start()
	#$TimerLabel.text = "Time left: %d" % round_time
	emit_signal("reset_scores")  # Signal PlayerScore to reset scores
	emit_signal("reset_timer")  # Signal PlayerScore to reset and start the timer
	emit_signal("next_round_started")

# Button pressed handler
func _on_button_pressed() -> void:
	emit_signal("next_round")
	hide()  # Hide the round winner scene 

# Handle starting the next round
func _on_next_round() -> void:
	reset_round_state()
	start_new_round()


func _on_reset_timer() -> void:
	reset_round_state()
	#$GameTimer.start()
