extends Control

signal command_queue(cmds: Array)
signal other(text: String)  # Let's there be other events besides commands

@onready var curr_view: HBoxContainer = %Lines.get_child(0)
@onready var regex: RegEx = RegEx.new()
@onready var history: PackedStringArray = PackedStringArray([""])
@onready var histind: int = 0


func get_cmdline(view: HBoxContainer) -> LineEdit:
	return view.get_child(1).get_child(0)


func connect_curr():
	get_cmdline(curr_view).text_submitted.connect(_on_command)


func update():

	var next_view: HBoxContainer = curr_view.duplicate()
	get_cmdline(next_view).text = ""
	get_cmdline(next_view).placeholder_text = ""

	get_cmdline(curr_view).editable = false

	curr_view = next_view
	%Lines.add_child(curr_view)
	connect_curr()

	# If there are more than three commands, remove the oldest one
	# This is a fix for the weird clipping I am sometimes seeing within the panel
	if len(%Lines.get_children()) > 3:
		%Lines.get_child(0).free()

	get_cmdline(curr_view).grab_focus()


func parse_input(raw: String, delim: String = ";") -> Array[PackedStringArray]:
	var parse: PackedStringArray = raw.split(delim)
	var queue: Array[PackedStringArray] = []
	for sec in parse:
		var cmd: Array[RegExMatch] = regex.search_all(sec.strip_edges())
		for tokens in cmd:
			if tokens != null:
				print_debug(tokens.get_string("cmd"), tokens.get_string("args"))
				queue.append(PackedStringArray([tokens.get_string("cmd"), tokens.get_string("args")]))
			else:
				return queue
	return queue


func _on_unpaused():
	get_cmdline(curr_view).grab_focus()


func _on_loss():
	set_process(false)
	get_cmdline(curr_view).editable = false
	get_cmdline(curr_view).release_focus()


func _on_command(raw: String) -> void:
	if raw.strip_edges() != "":
		history.append(raw)
		histind = 0
		var cmd_queue: Array[PackedStringArray] = parse_input(raw)
		if cmd_queue.is_empty():
			other.emit(raw)
		else:
			command_queue.emit(cmd_queue)
		update()


func _ready() -> void:
	get_cmdline(curr_view).grab_focus()
	regex.compile(r"^\s*(?<cmd>(?:l(?:eft)*)|(?:r(?:ight)*)|(?:j(?:ump)*)|(?:w(?:ait)*))\s*(?<args>(?:\d*\.)?\d*)?\s*$")  # Thank you regex101.com
	print_debug(regex.get_pattern())
	connect_curr()


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("up"):
		if histind < len(history) and not history.is_empty():
			get_cmdline(curr_view).text = history[histind]
			histind = histind + 1 if histind + 1 < len(history) else histind
	elif event.is_action_pressed("down"):
		if histind >= 0 and not history.is_empty():
			get_cmdline(curr_view).text = history[histind]
			histind -= 1 if histind - 1 >= 0 else 0
