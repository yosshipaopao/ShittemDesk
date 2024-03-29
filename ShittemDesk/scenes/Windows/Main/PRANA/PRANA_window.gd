extends Window

var PranaWindowVisible: bool = false:
	set(v):
		visible = v
		PranaWindowVisible = v
		process_mode = Node.PROCESS_MODE_ALWAYS if v else Node.PROCESS_MODE_DISABLED
		if v:
			Config.configs["PRANA:position"].default()
			Config.configs["PRANA:size"].default()
func _set_window_size(base_size:Vector2,scale:float):
	size = Vector2i(base_size*scale/100)

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
	Config.configs["PRANA:visible"].on_change(func(v:bool):PranaWindowVisible = v)
	Config.configs["PRANA:position"].on_change(move_window)
	Config.configs["PRANA:size"].on_change(func(v):window_scale=v)
