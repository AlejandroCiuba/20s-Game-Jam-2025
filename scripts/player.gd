extends Node2D

@export var speed: float = 7000
@export var jump: float = 1000
@export var gravity: float = 7000
@export var charbod: CharacterBody2D

var idle: bool = true

@onready var dir: Vector2 = Vector2.ZERO


func _on_bulk_command(cmds: Array[String], args: Array[PackedStringArray]):
	pass


func _on_command(cmd: String, args: PackedStringArray):
	match cmd:
		"left", "l":
			dir = Vector2.LEFT
			if not args.is_empty():
				await get_tree().create_timer(args[0] as float).timeout
				dir = Vector2.ZERO
		"right", "r":
			dir = Vector2.RIGHT
			if not args.is_empty():
				await get_tree().create_timer(args[0] as float).timeout
				dir = Vector2.ZERO
		"jump", "up", "j", "u":
			if not args.is_empty():
				await get_tree().create_timer(args[0] as float).timeout
			if charbod.is_on_floor():
				charbod.velocity.y = -jump
		"stop", "wait", "s", "w":
			dir = Vector2.ZERO
	anim_handler()


func _on_gate_player_entered() -> void:
	Manager.victory()


# TODO: Add a fail state
func _on_timeout():
	pass


func _on_player_anim_timer_timeout() -> void:
	if idle:
		if randf() > 0.5:
			%PlayerAnim.play("idle")
		else:
			%PlayerAnim.play("blink")


func _ready() -> void:
	%PlayerAnimTimer.start(randf() + 0.5)


func anim_handler() -> void:

	if is_zero_approx(dir.x) and charbod.is_on_floor():
		idle = true
	elif not is_zero_approx(dir.x) and charbod.is_on_floor():
		idle = false
		if dir.x > 0:
			$CharacterBody2D/Sprite2D.flip_h = false
			%PlayerAnim.play("move")
		else:
			$CharacterBody2D/Sprite2D.flip_h = true
			%PlayerAnim.play("move")

	if charbod.velocity.y < 0 and not is_zero_approx(charbod.velocity.y):
		%PlayerAnim.play("jump")

	print_debug("Current Animation: ", %PlayerAnim.current_animation)


func _physics_process(delta: float) -> void:

	charbod.velocity.x = speed * dir.x * delta
	charbod.velocity.y += gravity * delta
	charbod.move_and_slide()

	if charbod.velocity.y > 0 and not is_zero_approx(charbod.velocity.y):
		idle = false
		%PlayerAnim.play("land")

	if %PlayerAnim.current_animation == "land":
		anim_handler()
