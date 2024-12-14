extends Node3D




func _ready():
	randomize()
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	SetPlayers.connect("restart", Callable(self, "on_restart"))
	$PlayerScore.connect("end_round", Callable(self, "_on_end_round"))


func _input(event):
	if event.is_action_pressed("ui_cancel"):
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	if event.is_action_pressed("message"):
		$ChatControl.show()
	if event.is_action_pressed("release"):
		$ChatControl.hide()
		

func on_restart(peer_id):
	rpc("restart")
	#print("WORLD HAS BEEN CALLED")
	#print(peer_id)
	#print(multiplayer.get_peers())

@rpc("any_peer", "call_local")
func restart():
	if multiplayer.is_server():
		get_tree().change_scene_to_file("res://auth/server.tscn")
	else:
		get_tree().change_scene_to_file("res://auth/client.tscn")

func _on_end_round(scores, winners):
	var round_winner_scene = preload("res://RoundWinner.tscn").instantiate()
	get_tree().root.add_child(round_winner_scene)

	# Pass scores and winners to the scene
	round_winner_scene.display_winner(scores, winners)
	
