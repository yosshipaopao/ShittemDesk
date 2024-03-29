extends Panel


@onready var rng := $VBoxContainer/Inputs/SpinBox
func _on_spin_box_value_changed(value):
	Config.configs["Wallpaper:update_speed"].value = value

func _ready():
	Config.configs["Wallpaper:update_speed"].on_change(func(v):rng.value = v)
