extends Control

# Whether the mouse is moving the character
@export var moving := false

# context menu
@onready var context_menu := $ContextMenu
# Temporarily saved variable for the starting point when moving the window
var mouse_start : Vector2
# timer for auto close context menu
@onready var timer := $Timer
func _on_timer_timeout():context_menu.close()
# ARONA node
@onready var PRANA := $PRANA

var is_pressing := false
# charactor click event
func _on_control_gui_input(event) -> void:
	if event is InputEventMouseButton: # check if it is mouse event
		if event.button_index == MOUSE_BUTTON_LEFT: # left button
			BubbleWindow.visible = false # hide BubbleWindow (layer problem)
			context_menu.close()
			is_pressing = event.is_pressed()
			if is_pressing:
				mouse_start = get_viewport().get_mouse_position()
				await get_tree().create_timer(0.1).timeout
				moving = is_pressing# move charactor when clicked
				if moving:
					PRANA.now = "Picked" # set moving charactor model
					return	
			moving = false		
			Config.configs["PRANA:position"].value = PranaWindow.position
			PRANA.now = "Default" # set default characto model
		elif event.button_index == MOUSE_BUTTON_RIGHT:
			if event.is_pressed():
				timer.stop()
				context_menu.open(Vector2i(event.position) + PranaWindow.position)
				# set close after 3s
				timer.start(3)
### charactor control
# Temporary variable for the direction of orientation to prevent the mouse from suddenly turning to the center when the mouse is a certain distance away
var t_before := Vector2.ZERO
var sum_dist := 0.0
var dist_stack :Array[float]= []
# _ready()
func _ready() -> void:
	Config.configs["PRANA:size"].on_change(func(v):PRANA.scale = Vector2.ONE * v / 100)
	PRANA.now = "Default"
	for i in range(60):
		dist_stack.append(0.0)
func _process(_delta) -> void:
	# get mouse position
	var mouse_pos := get_viewport().get_mouse_position()
	if moving:
		# calculate diff and move window
		PranaWindow.move_window(Vector2(PranaWindow.position) + mouse_pos - mouse_start)
		#ARONA.expression("Halo",2) # change halo
	# calculate the direction to face
	var t :Vector2= (mouse_pos - Vector2(size)/2 + Vector2(0,size.y)/3.5) / (1.5*PranaWindow.window_scale)
	t.y *= -1
	
	var dist := t_before.distance_to(t)
	var next_face_exp := 0
	# If the mouse is too close
	if t.distance_to(Vector2.ZERO) < 0.3:
		PRANA.watch(Vector2.ZERO)
		PRANA.halo(3)
		next_face_exp = 1
	elif t.distance_to(Vector2.ZERO) < 2.0: 
		PRANA.watch(t)
	else:# If the mouse is too far away
		t=t_before/1.03
		PRANA.watch(t_before)
		PRANA.halo(0)
		dist = 0.0
	t_before = t
	sum_dist += dist
	dist_stack.append(dist)
	sum_dist -= dist_stack.pop_front()
	if sum_dist > 20.0:
		PRANA.halo(2)
		next_face_exp = 2
	PRANA.expression("Face",next_face_exp)
func _on_context_menu_settings_button_pressed():
	WindowManager.SettingsWindowVisible = true

func _on_context_menu_hide_button_pressed():
	Config.configs["PRANA:visible"].value = false

func _on_context_menu_music_button_pressed():
	MusicManager.visible = true
	MusicManager.position = PranaWindow.position + Vector2i(get_global_mouse_position())
