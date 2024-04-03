extends Panel

@onready var check_box = $Control/HBoxContainer/CheckBox

func _on_animated_button_pressed():
	OS.shell_open("https://github.com/yosshipaopao/ShittemDesk/releases/latest/download/ShittemDesk_Setup.msi")

func _ready():
	Config.configs["General:check_latest"].on_change(func(v):check_box.button_pressed = not v)


func _on_check_box_toggled(toggled_on):
	Config.configs["General:check_latest"].value = not toggled_on


func _on_animated_button_3_pressed():
	get_window().hide()
