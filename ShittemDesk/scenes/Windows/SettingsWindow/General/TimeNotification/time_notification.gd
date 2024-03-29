extends Panel

@onready var DetailSettingsWindow := $DetailSettingsWindow

func _on_button_pressed():
	DetailSettingsWindow.show()
