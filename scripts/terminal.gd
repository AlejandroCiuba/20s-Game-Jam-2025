extends Control

signal command_queue(cmds: Array)
signal other(text: String)  # Let's there be other events besides commands
@onready var curr_view: HBoxContainer = %Lines.get_child(0)
@onready var regex: RegEx = RegEx.new()


func _on_unpaused():
	curr_view.get_child(1).get_child(0).grab_focus()


func update():

	var next_view: HBoxContainer = curr_view.duplicate()
	next_view.get_child(1).get_child(0).text = ""
	next_view.get_child(1).get_child(0).placeholder_text = ""

	curr_view.get_child(1).get_child(0).editable = false

	curr_view = next_view
	%Lines.add_child(curr_view)

	# If there are more than three commands, remove the oldest one
	# This is a fix for the weird clipping I am sometimes seeing within the panel
	if len(%Lines.get_children()) > 3:
		%Lines.get_child(0).free()

	curr_view.get_child(1).get_child(0).grab_focus()


func _on_loss():
	set_process(false)
	curr_view.get_child(1).get_child(0).editable = false
	curr_view.get_child(1).get_child(0).release_focus()


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


func _ready() -> void:
	curr_view.get_child(1).get_child(0).grab_focus()
	regex.compile(r"^\s*(?<cmd>(?:l(?:eft)*)|(?:r(?:ight)*)|(?:j(?:ump)*)|(?:w(?:ait)*))\s*(?<args>(?:\d*\.)?\d*)?\s*$")  # Thank you regex101.com
	print_debug(regex.get_pattern())


func _process(_delta: float) -> void:

	if Input.is_action_just_pressed("command"):
		Manager.total_lines += 1
		var raw: String = curr_view.get_child(1).get_child(0).text.to_lower()
		if raw.strip_edges() != "":
			var cmd_queue: Array[PackedStringArray] = parse_input(raw)
			print_debug(cmd_queue)
			if cmd_queue.is_empty():
				other.emit(raw)
			command_queue.emit(cmd_queue)
			update()
