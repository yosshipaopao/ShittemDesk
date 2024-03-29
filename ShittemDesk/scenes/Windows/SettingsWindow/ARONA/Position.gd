extends Panel

@onready var button := $VBoxContainer/Inputs/AnimatedButton


func _on_pressed():
	var primary_window := DisplayServer.get_primary_screen()
	var window_position := DisplayServer.screen_get_position(primary_window)
	window_position += DisplayServer.screen_get_size(primary_window) / 2
	window_position -= Vector2i(265,438) / 2
	Config.configs["ARONA:position"].value = window_position
