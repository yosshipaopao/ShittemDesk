extends Panel

@onready var toggle := $VBoxContainer/Inputs/ON
func _on_toggled(toggled_on:bool) -> void:Config.configs["Wallpaper:visible"].value = toggled_on

func _ready():
	Config.configs["Wallpaper:visible"].on_change(func(v:bool):toggle.button_pressed = v)
