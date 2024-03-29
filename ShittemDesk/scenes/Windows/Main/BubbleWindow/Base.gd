extends Control


@onready var label := $Control/Control/Label
var text := ""
var text_len := 0
func speak(t:String):
	text = t
	text_len = t.length()
	label.text = ""

func _process(_delta):
	if label.text.length() != text_len:
		label.text += text[label.text.length()]
