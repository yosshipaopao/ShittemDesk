extends Panel


func _on_button_pressed():
	Config.reset()
	WindowManager.SettingsWindowVisible = false
	get_tree().root.propagate_notification(NOTIFICATION_WM_CLOSE_REQUEST)
