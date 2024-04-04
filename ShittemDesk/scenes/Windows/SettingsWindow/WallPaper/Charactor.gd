extends Panel
@onready var on = $VBoxContainer/Inputs/ON

func _ready():
	Config.configs["Wallpaper:charactor"].on_change(func(v):on.button_pressed=v)

func _on_on_toggled(toggled_on):
	Config.configs["Wallpaper:charactor"].value=toggled_on
