extends Control

var window:Window
var moving:=[false,false]
var mouse_start:Vector2i
func _ready():
	window = get_tree().root.get_window()
	window.size = Vector2i(800,500)
	window.min_size = Vector2i(500,200)
	window.move_to_center()

func _process(_delta):
	if resizing[0] or resizing[1] or moving[0] or moving[1]:
		var mouse_now := Vector2i(get_viewport().get_mouse_position())
		var window_pos_diff := mouse_now - mouse_start
		
		if moving[0] and resizing[0]:
			window.size.x -= window_pos_diff.x
			if window.size.x != window.min_size.x:
				window.position.x += window_pos_diff.x
		elif moving[0]:
			window.position.x+=window_pos_diff.x
		elif resizing[0]:
			window.size.x = mouse_now.x
		
		if moving[1] and resizing[1]:
			window.size.y -= window_pos_diff.y
			if window.size.y != window.min_size.y:
				window.position.y += window_pos_diff.y
		elif moving[1]:
			window.position.y+=window_pos_diff.y
		elif resizing[1]:
			window.size.y = mouse_now.y

@onready
var Tabs:= {
	"General" : %General,	
	"Wallpaper" : %Wallpaper,
	"ARONA" :%ARONA,
	"PRANA": %PRANA
}
var selected := "General" :
	set(v):
		for k in Tabs:
			Tabs[k].visible = k == v
		selected = v
func _on_close_button_pressed():WindowManager.SettingsWindowVisible = false
signal titlebar_clicked(event:InputEvent)
func _on_title_bar_gui_input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			moving = [event.is_pressed(),event.is_pressed()]
			if moving[0]:
				mouse_start = get_viewport().get_mouse_position()

func _on_general_toggled(toggled_on):
	if toggled_on:selected="General"
func _on_wallpaper_toggled(toggled_on):
	if toggled_on:selected="Wallpaper"
func _on_arona_toggled(toggled_on):
	if toggled_on:selected="ARONA"
func _on_prana_toggled(toggled_on):
	if toggled_on:selected="PRANA"
var resizing:= [false,false]

func _on_top_handler_gui_input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		resizing[1] = event.is_pressed()
		moving[1] = event.is_pressed()
		mouse_start = get_viewport().get_mouse_position()
func _on_bottom_handler_gui_input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		resizing[1] =  event.is_pressed()
func _on_left_handler_gui_input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		resizing[0] = event.is_pressed()
		moving[0] = event.is_pressed()
		mouse_start = get_viewport().get_mouse_position()
func _on_right_handler_gui_input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		resizing[0] = event.is_pressed()
func _on_top_left_handler_gui_input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		resizing = [event.is_pressed(),event.is_pressed()]
		moving = [event.is_pressed(),event.is_pressed()]
		mouse_start = get_viewport().get_mouse_position()
func _on_top_right_handler_gui_input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		resizing = [event.is_pressed(),event.is_pressed()]
		moving[1] = event.is_pressed()
		mouse_start = get_viewport().get_mouse_position()
func _on_bottom_left_handler_gui_input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		resizing = [event.is_pressed(),event.is_pressed()]
		moving[0] = event.is_pressed()
		mouse_start = get_viewport().get_mouse_position()
func _on_bottom_right_handler_gui_input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		resizing = [event.is_pressed(),event.is_pressed()]


