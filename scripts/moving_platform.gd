extends Node2D

@export var speed: float = 200.0

@onready var body: RigidBody2D = $RigidBody2D
@onready var sprite: Sprite2D = $RigidBody2D/Sprite2D

func _ready():
	increase_size(10, 8.0, 2.0)


func _physics_process(delta: float) -> void:
	var velocity: Vector2 = Vector2.RIGHT * speed
	body.move_and_collide(velocity * delta)


func increase_size(final_scale: int, duration: float, step: float):
	for i in range(final_scale):
		await get_tree().create_timer(step).timeout
		sprite.scale += Vector2(final_scale / duration * step, final_scale / duration * step)
