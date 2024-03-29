extends Window

var AronaWindowVisible: bool = false:
	set(v):
		visible = v
		AronaWindowVisible = v
		process_mode = Node.PROCESS_MODE_ALWAYS if v else Node.PROCESS_MODE_DISABLED
		if v:
			Config.configs["ARONA:position"].default()
			Config.configs["ARONA:size"].default()
func _set_window_size(base_size:Vector2,scale:float):size = Vector2i(base_size*scale/100)

# tween of window positon
var window_tween : Tween
# move window using tween
func move_window(v:Vector2) -> void:
	if window_tween:
		window_tween.kill()
	window_tween = create_tween()
	window_tween.tween_property(self,"position",Vector2i(v),0.1)
	window_tween.play()

var window_base_size := Vector2(300,300):
	set(v):
		_set_window_size(v,window_scale)
		window_base_size = v
var window_scale :float= 100 :
	set(v):
		_set_window_size(window_base_size,v)
		window_scale = v

func _ready() -> void:
	Config.configs["ARONA:visible"].on_change(func(v:bool):AronaWindowVisible = v)
	Config.configs["ARONA:position"].on_change(move_window)
	Config.configs["ARONA:size"].on_change(func(v):window_scale=v)
