extends Node2D

var arrow_scence = preload("res://arrow.tscn")

var player

func _ready():
	if Input.is_action_just_pressed("Press_C"):
		print("Arrow")
		player = get_node("../../Player/Player")
		var arrow = arrow_scence.instantiate()
		arrow.position = Vector2(player.position.x, player.position.y)
		add_child(arrow)
		print(arrow.position)
		
