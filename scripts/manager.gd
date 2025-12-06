extends Node

var total_lines: int = 0
var final_time: float = 20.0
var mute: bool = false

func change_scene(scene: String):
	(func (): get_tree().change_scene_to_file(scene)).call_deferred()


func victory():
	(func (): get_tree().change_scene_to_file("res://scenes/screens/victory.tscn")).call_deferred()
