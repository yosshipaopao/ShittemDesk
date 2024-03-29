extends Panel

@onready var win := $Window
var fist_check = true
func _ready():
	Config.configs["AgreedToTermsOfUse"].on_change(func(v):
		if fist_check:
			if v:
				win.hide()
			else:
				win.show()
		fist_check = false
		)

func _on_button_pressed():
	win.show()


func _on_window_close_requested():
	win.hide()
	if not Config.configs["AgreedToTermsOfUse"].value:
		WindowManager.SettingsWindowVisible = false
		get_tree().root.propagate_notification(NOTIFICATION_WM_CLOSE_REQUEST)
