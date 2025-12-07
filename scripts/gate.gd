extends Area2D

signal player_entered


func _ready() -> void:
	%GateAnim.play("gate")


func _on_body_entered(_body: Node2D) -> void:
	(func(): player_entered.emit()).call_deferred()
