extends Panel



func _ready():
	Config.configs["General:FPS"].on_change(func(v:int):
		Engine.set_max_fps(v)
		for k in general_fps:
			k.value=v
	)

@onready
var general_fps := [
	$Control/Inputs/HSlider,
	$Control/Inputs/SpinBox
]
func _on_size_value_changed(value):
	Config.configs["General:FPS"].value = value
