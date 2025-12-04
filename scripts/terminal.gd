extends Control

signal command_queue(cmds: Array)
@onready var curr_view: HBoxContainer = %Lines.get_child(0)


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


func _ready() -> void:
	curr_view.get_child(1).get_child(0).grab_focus()


func _process(_delta: float) -> void:

	if Input.is_action_just_pressed("command"):

		Manager.total_lines += 1

		var cmd_queue: Array = []
		var cmd: String = curr_view.get_child(1).get_child(0).text.strip_escapes().replace(" ", "").to_lower()
		print_debug(cmd)

		if not cmd.is_empty():
			for subcmd in cmd.split(";"):
				if not subcmd.strip_edges().is_empty():
					var parse: PackedStringArray = subcmd.strip_edges().split("")  # TODO: Fix parsing error for decimal numbers
					print_debug(parse)
					if len(parse) > 1:
						cmd_queue.append([parse[0], parse.slice(1)])
					else:
						cmd_queue.append([parse[0], PackedStringArray()])
			command_queue.emit(cmd_queue)

			update()
