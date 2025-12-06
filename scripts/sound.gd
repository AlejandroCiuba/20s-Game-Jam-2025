extends Control

@export var textures: Array[Texture2D]


func _on_sound_pressed() -> void:
	Manager.mute = not Manager.mute
	AudioServer.set_bus_mute(AudioServer.get_bus_index("Master"), Manager.mute)
	%Sound.texture_normal = textures[Manager.mute as int]


func _ready() -> void:
	%Sound.texture_normal = textures[Manager.mute as int]
