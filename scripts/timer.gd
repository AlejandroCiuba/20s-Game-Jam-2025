extends Control

var curr_time: float = 20.0

signal timeout

@export var time: float = 20.0


func _ready() -> void:
	%TimerDisplay.text = "[b]%.3f[/b]" % 0.0
	start_timer(time, true, true)

func start_timer(seconds: float, countdown: bool = true, display_ms: bool = true):

	%TimerDisplay.text = "[b]%.2f[/b]" % (seconds if not countdown else seconds)
	var ms: float = 1.0 if not display_ms else 1E1 as float  # Cannot display anything smaller as it is too fast to accurately get
	for second in range(1, seconds * ms + 1):
		await get_tree().create_timer(1.0 / ms, false).timeout
		curr_time = second / ms as float if not countdown else seconds - (second / ms)
		%TimerDisplay.text = "[b]%.2f[/b]" % curr_time

	timeout.emit()
