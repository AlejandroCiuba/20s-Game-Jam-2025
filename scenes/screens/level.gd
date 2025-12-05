extends Node2D

signal loss


func _on_gate_player_entered() -> void:
	Manager.final_time = $Canvases/UILayer/Timer.curr_time as float
	Manager.victory()


func _on_ui_timeout() -> void:
	loss.emit()
