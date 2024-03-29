extends Panel

@onready var line_edit := $Control/Inputs/LineEdit
func _on_speak_button_pressed():
	BubbleWindow.speak(line_edit.text)
