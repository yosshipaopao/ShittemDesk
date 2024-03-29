extends Control


@onready var title_label := $Panel/ClickHandler/Top/Title
@onready var artist_label := $Panel/ClickHandler/Control/Artist

func _ready():
	GlobalMediaSession.song_changed.connect(func():
		title_label.text = GlobalMediaSession.get_media_title()
		artist_label.text = GlobalMediaSession.get_media_artist()
		)

func _on_play_button_pressed():GlobalMediaSession.toggle_play_pause_media()

func _on_close_button_pressed():get_parent().visible = false

func _process(_delta):
	seek_slider.max_value = GlobalMediaSession.duration
	if not _dragging:
		seek_slider.value = GlobalMediaSession.seek

@onready var seek_slider := %HSlider
var _dragging := false
func _on_h_slider_drag_started():_dragging  = true
func _on_h_slider_drag_ended(_value_changed):
	_dragging = false
	GlobalMediaSession.seek = seek_slider.value

@onready var parent := get_parent()
func _on_click_handler_gui_input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			parent.moving = [event.is_pressed(),event.is_pressed()]
			if parent.moving[0]:
				parent.mouse_start = get_viewport().get_mouse_position()

func _on_top_handler_gui_input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		parent.resizing[1] = event.is_pressed()
		parent.moving[1] = event.is_pressed()
		parent.mouse_start = get_viewport().get_mouse_position()
func _on_bottom_handler_gui_input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		parent.resizing[1] =  event.is_pressed()
func _on_left_handler_gui_input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		parent.resizing[0] = event.is_pressed()
		parent.moving[0] = event.is_pressed()
		parent.mouse_start = get_viewport().get_mouse_position()
func _on_right_handler_gui_input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		parent.resizing[0] = event.is_pressed()
func _on_top_left_handler_gui_input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		parent.resizing = [event.is_pressed(),event.is_pressed()]
		parent.moving = [event.is_pressed(),event.is_pressed()]
		parent.mouse_start = get_viewport().get_mouse_position()
func _on_top_right_handler_gui_input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		parent.resizing = [event.is_pressed(),event.is_pressed()]
		parent.moving[1] = event.is_pressed()
		parent.mouse_start = get_viewport().get_mouse_position()
func _on_bottom_left_handler_gui_input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		parent.resizing = [event.is_pressed(),event.is_pressed()]
		parent.moving[0] = event.is_pressed()
		parent.mouse_start = get_viewport().get_mouse_position()
func _on_bottom_right_handler_gui_input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		parent.resizing = [event.is_pressed(),event.is_pressed()]

