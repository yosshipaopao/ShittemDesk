extends Window

func _on_close_button_pressed():
	hide()

var moving:=[false,false]
var resizing:= [false,false]
var mouse_start:Vector2i

func _process(_delta):
	if resizing[0] or resizing[1] or moving[0] or moving[1]:
		var mouse_now := Vector2i(get_viewport().get_mouse_position())
		var window_pos_diff := mouse_now - mouse_start
		
		if moving[0] and resizing[0]:
			size.x -= window_pos_diff.x
			if size.x != min_size.x:
				position.x += window_pos_diff.x
		elif moving[0]:
			position.x+=window_pos_diff.x
		elif resizing[0]:
			size.x = mouse_now.x
		
		if moving[1] and resizing[1]:
			size.y -= window_pos_diff.y
			if size.y != min_size.y:
				position.y += window_pos_diff.y
		elif moving[1]:
			position.y+=window_pos_diff.y
		elif resizing[1]:
			size.y = mouse_now.y

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

func _on_title_bar_gui_input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			moving = [event.is_pressed(),event.is_pressed()]
			if moving[0]:
				mouse_start = get_viewport().get_mouse_position()
