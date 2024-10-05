extends Node2D




func _on_out_of_bounds_body_exited(body):
	print(body.name)
	if body.name == "Player":
		print("OB")
		get_tree().change_scene_to_file("res://main.tscn")
