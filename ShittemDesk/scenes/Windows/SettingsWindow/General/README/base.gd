extends Control

@onready var close_btn := $Control/Panel/Control/AnimatedButton
@onready var checkbox := $Control/Panel/Control/CheckBox

func _ready():
	Config.configs["AgreedToTermsOfUse"].on_change(func(v):	checkbox.button_pressed = v)

func _on_animated_button_pressed():
	get_window().hide()
	WindowManager.SettingsWindowVisible = true
	Config.configs["ARONA:visible"].value = true

func _on_check_box_toggled(toggled_on):
	Config.configs["AgreedToTermsOfUse"].value = toggled_on
	close_btn.visible = toggled_on
