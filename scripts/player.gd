extends Node2D

@export var speed: float = 7000
@export var jump: float = 1000
@export var gravity: float = 7000
@export var charbod: CharacterBody2D

var failed: bool = false
var cmd_queue: Array = []

var idle: bool = true  # Just for the idle animation
var falling: bool = false  # Just for the falling animation
var prev_anim: String = "wait"

@onready var dir: Vector2 = Vector2.ZERO

func move(direction: Vector2, time: float = 0.0):
	if direction != Vector2.UP:
		dir = direction
	if not is_equal_approx(time, 0.0):
		await get_tree().create_timer(time).timeout
		if direction != Vector2.UP:  # Jump will continue unless it waits
			dir = Vector2.ZERO
	if direction == Vector2.UP:
		charbod.velocity.y = -jump


func process_command(cmd: String, args: PackedStringArray):
	match cmd:
		"left", "l":
			anim_handler("left")
			await move(Vector2.LEFT, 0.0 if args.is_empty() else (args[0] as float))
			if not args.is_empty():  # Wait if there was a time limit to the movement
				anim_handler("wait")
			prev_anim = %PlayerAnim.current_animation
		"right", "r":
			anim_handler("right")
			await move(Vector2.RIGHT, 0.0 if args.is_empty() else (args[0] as float))
			if not args.is_empty():
				anim_handler("wait")
			prev_anim = %PlayerAnim.current_animation
		"jump", "up", "j", "u":
			await move(Vector2.UP, 0.0 if args.is_empty() else (args[0] as float))
			anim_handler("jump")
		"stop", "wait", "s", "w":
			anim_handler("wait")
			await move(Vector2.ZERO, 0.0 if args.is_empty() else (args[0] as float))
			prev_anim = %PlayerAnim.current_animation


func _on_command(cmds: Array):
	cmd_queue = cmds  # New commands overwrite previous ones
	print_debug("COMMAND QUEUE:", cmd_queue)
	while not cmd_queue.is_empty():
		var next = cmd_queue.pop_front()
		print_debug("Next:", next)
		await process_command(next[0], next[1])


func _on_loss():
	failed = true
	set_physics_process(false)
	anim_handler("loss")


func _on_player_anim_timer_timeout() -> void:
	if idle and not failed:
		anim_handler("wait")


func anim_handler(animation: String) -> void:

	# Checks for idling since we are randomly looping through idle animations
	if animation not in ["wait", "idle", "blink"]:
		idle = false
	else:
		idle = true

	match animation:
		"left":
			$CharacterBody2D/Sprite2D.flip_h = true
			%PlayerAnim.play("move")
		"right":
			$CharacterBody2D/Sprite2D.flip_h = false
			%PlayerAnim.play("move")
		"jump":
			%PlayerAnim.play("jump")
		"wait":
			if randf() > 0.5:
				%PlayerAnim.play("idle")
			else:
				%PlayerAnim.play("blink")
		"land":
			%PlayerAnim.play("land")
		"loss":
			%PlayerAnim.play("fail")
			await %PlayerAnim.animation_finished
			%PlayerAnim.play("fail_end")
		var true_name:
			%PlayerAnim.play(true_name)

	#print_debug("Current Animation: ", %PlayerAnim.current_animation)


func _ready() -> void:
	%PlayerAnimTimer.start(randf() + 0.5)


# Handles the player falling and then resuming the previous animation after the fall
func _process(_delta: float) -> void:
	if not charbod.is_on_floor() and charbod.velocity.y > 0 and not falling:
		falling = true
		anim_handler("land")
	elif charbod.is_on_floor() and falling:
		falling = false
		anim_handler(prev_anim)

func _physics_process(delta: float) -> void:
	charbod.velocity.x = speed * dir.x * delta
	charbod.velocity.y += gravity * delta
	charbod.move_and_slide()
