extends Control

@export var character: String = ""
@export_multiline var text: String = ""
@export var text_time: float = 0.5

var dialog_size: Vector2 = Vector2.ZERO

signal rendered


func render_text() -> void:
	for c in text:
		%Dialog.text += c
		await get_tree().create_timer(text_time, false).timeout
	rendered.emit()


func spawn_dialog(header: String, dialog: String, loc: Vector2) -> void:
	global_position = loc
	set_dialog(header, dialog)


func set_dialog(header: String, dialog: String, clear_text: bool = true, change_size: bool = true) -> void:
	%Name.text = header
	text = dialog
	if change_size:
		set_dialog_size(text)
	if clear_text:
		%Dialog.text = ""
	render_text()


func set_dialog_size(dialog: String) -> Vector2:
	var text_size: Vector2 = Vector2.ZERO
	if dialog.contains("\n"):
		print_debug("Multiline!")
		text_size = %Dialog.get_theme_font("bold_font").get_multiline_string_size(text, HORIZONTAL_ALIGNMENT_LEFT, -1, %Dialog.get_theme_font_size("bold_font_size")) + Vector2(0.0, 8 * len(dialog.split("\n")))  # Paragraph separation between newlines
	else:
		text_size = %Dialog.get_theme_font("bold_font").get_string_size(text, HORIZONTAL_ALIGNMENT_LEFT, -1, %Dialog.get_theme_font_size("bold_font_size"))
	dialog_size = text_size + Vector2(32, 32)  # 16 for the two margins and 16 for the two borders
	%DialogContainer.custom_minimum_size = dialog_size
	return dialog_size
