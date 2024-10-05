extends Node2D

var enemy_scene = preload("res://Enemies/Knight.tscn")


func _on_timer_timeout():
	var enemy = enemy_scene.instantiate()
	enemy.position = Vector2(randf_range(40, 1000), 500)
	add_child(enemy)
