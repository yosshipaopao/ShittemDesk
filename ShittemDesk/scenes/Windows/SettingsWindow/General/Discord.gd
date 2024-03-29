extends Panel

@onready var toggle_buttons : Array[Button]= [
	$VBoxContainer/Inputs/OFF,
	$VBoxContainer/Inputs/ON,
	$VBoxContainer/Inputs/ON_PLUS
]
func _ready():
	Config.configs["General:Discord"].on_change(func(v:int):
		for i in range(toggle_buttons.size()):
			toggle_buttons[i].button_pressed = (i==v)
		)

func _on_on_plus_pressed():
	Config.configs["General:Discord"].value = 2

func _on_on_pressed():
	Config.configs["General:Discord"].value = 1

func _on_off_pressed():
	Config.configs["General:Discord"].value = 0
