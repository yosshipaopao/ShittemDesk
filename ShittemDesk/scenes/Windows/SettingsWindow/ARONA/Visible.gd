extends Panel

@onready var toggle_button := $VBoxContainer/Inputs/ON
func _on_toggled(toggled_on:bool) -> void:Config.configs["ARONA:visible"].value = toggled_on
func _ready():
	Config.configs["ARONA:visible"].on_change(func(v:bool):toggle_button.button_pressed = v)
