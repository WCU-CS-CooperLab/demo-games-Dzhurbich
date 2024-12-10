extends Node

func _ready():
	var level_num = str(GameState.current_level).pad_zeros(2)  # Format with leading zeros
	var path_with_zero = "res://levels/level_%s.tscn" % level_num
	var path_without_zero = "res://levels/level_%d.tscn" % GameState.current_level

	var path = ""
	if FileAccess.file_exists(path_with_zero):
		path = path_with_zero
	elif FileAccess.file_exists(path_without_zero):
		path = path_without_zero
	else:
		print("Error: Neither path exists:", path_with_zero, "or", path_without_zero)
		return

	print("Attempting to load level at path:", path)
	var level = load(path)
	if not level:
		print("Error: Failed to load level scene at path:", path)
	else:
		add_child(level.instantiate())
		print("Successfully loaded level:", path)
