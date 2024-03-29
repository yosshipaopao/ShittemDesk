extends Window


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
	
