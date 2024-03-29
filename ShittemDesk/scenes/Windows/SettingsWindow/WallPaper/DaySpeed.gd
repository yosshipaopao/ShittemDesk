extends Panel

@onready var rng := $VBoxContainer/Inputs/SpinBox
func _on_spin_box_value_changed(value):
	Config.configs["Wallpaper:day_speed"].value = value

func _ready():
	Config.configs["Wallpaper:day_speed"].on_change(func(v):rng.value = v)
