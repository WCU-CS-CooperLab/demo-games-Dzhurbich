extends Control
func _ready():
	print("Title scene is active!")

func input(event):
	print("event recieved:" , event)
	if event.is_action_pressed("ui_select"):
		print("ui_select pressed!") 
		if GameState:
			GameState.next_level()
		else:
			print("Error: game state not accessible")
