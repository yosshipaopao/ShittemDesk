extends Window

func open(pos:Vector2i) -> void:
	visible = true
	position = pos
func close() -> void:
	visible = false


signal settings_button_pressed()
signal hide_button_pressed()
signal music_button_pressed()


func _on_settings_button_pressed() -> void:
	settings_button_pressed.emit()
	close()
func _on_hide_button_pressed() -> void:
	hide_button_pressed.emit()
	close()
func _on_music_button_pressed():
	music_button_pressed.emit()
	close()
