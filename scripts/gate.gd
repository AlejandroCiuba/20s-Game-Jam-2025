extends Node2D

signal player_entered


func _ready() -> void:
	%GateAnim.play("gate")


func _on_area_2d_body_entered(_body: Node2D) -> void:
	print_debug("EMIT")
	(func(): player_entered.emit()).call_deferred()
