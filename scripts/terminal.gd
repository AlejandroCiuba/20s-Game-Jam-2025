extends Control

signal command_queue(cmds: Array)
signal other(text: String)  # Let's there be other events besides commands

var can_rapid_scroll: bool = false
var rapid_scroll_wait: float = 1.0
var rapid_scroll_press: float = 0.0

var regex: RegEx = RegEx.new()
var num: RegEx = RegEx.new()

var history: PackedStringArray = PackedStringArray([""])
var histind: int = 0

@onready var curr_view: HBoxContainer = %Lines.get_child(0)


func get_cmdline(view: HBoxContainer) -> LineEdit:
	return view.get_child(1).get_child(0)


func connect_curr() -> void:
	get_cmdline(curr_view).text_submitted.connect(_on_command)


func update() -> void:

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

	Manager.total_lines += 1
	get_cmdline(curr_view).grab_focus()


# This is not a robust parser
# S -> X | pn* | (pn*)n*
# X -> p*n*;X*
# n -> [0-9]+ | [0-9]+.[0.9]* | [0-9]*.[0.9]+
# p -> (pn*) | [lrjw]
func expand_parens(raw: String) -> String:
	var expanded: String = raw
	var left_ind: int = 0
	while '(' in expanded:
		var buffer: String = expanded
		for ind in range(len(expanded)):
			var token: String = expanded[ind]
			if token == '(':
				left_ind = ind
			elif token == ')':
				var info: String = expanded.substr(left_ind + 1)
				var find: RegExMatch = num.search(info)
				var reps: int = find.get_string("reps") as int if find != null else 1
				var sub: String = (";" + info.split(')')[0] + ";").repeat(reps)
				buffer = expanded.substr(0, left_ind) + sub + expanded.substr(ind + 1 + (len("%d" % reps) if find != null else 0 ), -1)
				break
		expanded = buffer
		print_debug(expanded)
	return expanded


func correct_parens(raw: String) -> bool:
	var right: int = 0
	var left: int = 0
	for token in raw:
		if token == '(':
			left += 1
		elif token == ')':
			right += 1
		if right > left:
			return false
	if left == right:
		return true
	return false


func parse_input(raw: String, delim: String = ";") -> Array[PackedStringArray]:
	var queue: Array[PackedStringArray] = []
	# 1. Check for parentheses
	if '(' in raw or ')' in raw:
		if not correct_parens(raw):
			return queue
		else:
			raw = expand_parens(raw)
	var parse: PackedStringArray = raw.split(delim)
	for sec in parse:
		var cmd: Array[RegExMatch] = regex.search_all(sec.strip_edges())
		for tokens in cmd:
			if tokens != null:
				print_debug(tokens.get_string("cmd"), tokens.get_string("args"))
				queue.append(PackedStringArray([tokens.get_string("cmd"), tokens.get_string("args")]))
			else:
				return queue
	return queue


func _on_unpaused() -> void:
	get_cmdline(curr_view).grab_focus()


func _on_loss() -> void:
	set_process(false)
	get_cmdline(curr_view).editable = false
	get_cmdline(curr_view).release_focus()


func _on_command(raw: String) -> void:
	if raw.strip_edges() != "":
		history.insert(1, raw)
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
	num.compile(r"\)(?<reps>\d+)")
	connect_curr()


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_text_caret_up") or (event.is_action("ui_text_caret_up") and can_rapid_scroll):
		histind = (histind + 1) % len(history)
		get_cmdline(curr_view).text = history[histind]
		get_cmdline(curr_view).caret_column = get_cmdline(curr_view).text.length()
		get_viewport().set_input_as_handled()
	elif event.is_action_pressed("ui_text_caret_down") or (event.is_action("ui_text_caret_down") and can_rapid_scroll):
		histind = (histind - 1) % len(history)
		get_cmdline(curr_view).text = history[histind]
		get_cmdline(curr_view).caret_column = get_cmdline(curr_view).text.length()
		get_viewport().set_input_as_handled()


func _process(delta: float) -> void:
	if Input.is_action_pressed("ui_text_caret_up") or Input.is_action_pressed("ui_text_caret_down"):
		rapid_scroll_press += delta
	elif Input.is_action_just_released("ui_text_caret_up") or Input.is_action_just_released("ui_text_caret_up"):
		can_rapid_scroll = false
		rapid_scroll_press = 0
	if rapid_scroll_press >= rapid_scroll_wait:
		can_rapid_scroll = true
