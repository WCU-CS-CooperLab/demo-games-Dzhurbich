extends Node

var num_levels = 1
var current_level = 1
var game_scene = "res://main.tscn"
var title_screen = "res://ui/title.tscn"

func restart():
	current_level = 0
	get_tree().change_scene_to_file(title_screen)
	
func next_level():
	current_level += 1
	var level_path = "res://levels/level_%02d.tscn" % current_level
	print("next level path:", level_path)
	var level_num = str(current_level).pad_zeros(2)
	game_scene = "res://levels/level_%s.tscn" % level_num
	print("Loading game scene:", game_scene)
	if get_tree().change_scene_to_file(game_scene) != OK:
		print("Error: Failed to load scene:", game_scene)
