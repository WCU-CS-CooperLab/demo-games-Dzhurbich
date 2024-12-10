extends CanvasLayer
signal start_game
signal toggle_cacti

func update_score(value):
	$MarginContainer/Score.text = str(value)
	
func update_timer(value):
	$MarginContainer/Time.text = str(value)
	
func show_message(text):
	$Message.text = text
	$Message.show()
	$Timer.start()

func update_wave_count(wave):
	$Wave.text = "Wave: %d" % wave
# Called when the node enters the scene tree for the first time.

func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_timer_timeout() -> void:
	$Message.hide()


func _on_start_button_pressed() -> void:
	$StartButton.hide()
	$Message.hide()
	$VBoxContainer/Toggle_Music.hide()
	start_game.emit()
	$AudioStreamPlayer.play()


func show_game_over():
	show_message("Game Over")
	await $Timer.timeout
	$StartButton.show()
	$Message.text= "Coin Dash!"
	$Message.show()
	
func toggle_pause_menu():
	if $PauseMenu.visible:
		$PauseMenu.hide()
		get_tree().paused = false
	else:
		$PauseMenu.show()
		get_tree().paused = true


func _on_resume_pressed() -> void:
	toggle_pause_menu()


func _on_toggle_on_off_toggled(toggled_on: bool) -> void:
	var music_player = $AudioStreamPlayer
	if music_player.playing:
		music_player.stop()
	else:
		music_player.play()


func _on_toggle_music_toggled(toggled_on: bool) -> void:
	pass # Replace with function body.


func _on_toggle_music_pressed() -> void:
	# Reference the AudioStreamPlayer node
	var audio_player = $AudioStreamPlayer

	# Check if the audio is currently playing
	if audio_player.playing:
		audio_player.stop()  # Stop the music
	else:
		audio_player.play()  # Start the music
