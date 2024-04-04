extends Panel

@onready var http_request = $HTTPRequest
@onready var version_check_window = $VersionCheckWindow
@onready var check_box = $Control/Inputs/CheckBox

var current_version :String= ProjectSettings.get_setting("application/config/version")
@onready var label = $Control/Inputs/Label


func _ready():
	Config.configs["General:check_latest"].on_change(func(v):check_box.button_pressed = v)
	if Config.configs["General:check_latest"].value:
		http_request.request("https://api.github.com/repos/yosshipaopao/ShittemDesk/releases/latest")
	label.text = "Now: v"+current_version
	
@onready var latest_version_label = $VersionCheckWindow/Panel/Control2/VBoxContainer/LatestVersionLabel

func _on_http_request_request_completed(_result, _response_code, _headers, body):
	var json = JSON.new()
	json.parse(body.get_string_from_utf8())
	var response = json.get_data()
	if "v" + current_version != response["tag_name"]:
		version_check_window.popup_centered()
		version_check_window.move_to_foreground()
		version_check_window.grab_focus()
		latest_version_label.text = response["tag_name"]

func _on_button_pressed():
	http_request.request("https://api.github.com/repos/yosshipaopao/ShittemDesk/releases/latest")

func _on_animated_button_toggled(toggled_on):
	Config.configs["General:check_latest"].value = toggled_on
