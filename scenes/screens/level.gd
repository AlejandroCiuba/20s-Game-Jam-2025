extends Node2D

signal loss


func _on_gate_player_entered() -> void:
	Manager.victory()


func _on_ui_timeout() -> void:
	loss.emit()
