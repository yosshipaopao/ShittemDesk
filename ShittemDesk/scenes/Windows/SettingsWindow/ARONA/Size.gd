extends Panel


@onready var ranges := [
	$VBoxContainer/Inputs/HSlider,
	$VBoxContainer/Inputs/SpinBox,
]
func _on_value_changed(value):
	Config.configs["ARONA:size"].value = int(value)
	
func _ready() -> void:
	Config.configs["ARONA:size"].on_change(func(v):for k in ranges:k.value=v)
