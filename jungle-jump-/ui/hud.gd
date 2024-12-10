extends MarginContainer

@onready var life_counter = $HBoxContainer/LifeCounter.get_children()

func update_life(value):
	for heart in range(life_counter.size()):
		life_counter[heart].visible = value > heart
		
func update_score(value):
	$HBoxContainer/Score.text = str(value)


func life_changed() -> void:
	pass # Replace with function body.
