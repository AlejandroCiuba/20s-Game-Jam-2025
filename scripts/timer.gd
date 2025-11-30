extends Control


signal timeout

@export_group("Margins")
@export var left: float = 0.0
@export var top: float = 0.0
@export var right: float = 0.0
@export var bottom: float = 0.0


func _ready() -> void:
	%TimerDisplay.text = "[b]%.3f[/b]" % 0.0
	start_timer(20.0, true, true)

func start_timer(seconds: float, countdown: bool = true, display_ms: bool = true):

	%TimerDisplay.text = "[b]%.2f[/b]" % (seconds if not countdown else seconds)
	var ms: float = 1.0 if not display_ms else 1E1 as float  # Cannot display anything smaller as it is too fast to accurately get
	for second in range(1, seconds * ms + 1):
		await get_tree().create_timer(1.0 / ms).timeout
		%TimerDisplay.text = "[b]%.2f[/b]" % (second / ms as float if not countdown else seconds - (second / ms))

	timeout.emit()
