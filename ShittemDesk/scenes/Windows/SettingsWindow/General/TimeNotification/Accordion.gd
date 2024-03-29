@tool
extends VBoxContainer

@onready var content := $Content

func _on_header_pressed():
	content.visible = !content.visible


func _on_content_gui_input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.is_pressed():
			content.visible=false
