extends Panel


@onready var ranges := [
	$VBoxContainer/Inputs/HSlider,
	$VBoxContainer/Inputs/SpinBox,
]
func _on_value_changed(value):
	Config.configs["PRANA:size"].value = int(value)
	
func _ready() -> void:
	Config.configs["PRANA:size"].on_change(func(v):for k in ranges:k.value=v)
