extends SubViewport


@onready var sky := $World
func _ready():
	Config.configs["Wallpaper:day_speed"].on_change(func(v):sky.day_speed = v)
	Config.configs["Wallpaper:update_speed"].on_change(func(v):update_speed=v)
	Config.configs["Wallpaper:visible"].on_change(func(v):
		WallpaperWindow.WallpaperVisible = v
		if v:
			sky.time = (TimeManager.hour * 60 + TimeManager.minute) * 60 + TimeManager.second	
			Config.configs["Wallpaper:day_speed"].default()
			Config.configs["Wallpaper:update_speed"].default()
			
	)

var cnt := 0
var update_speed := 4
func _process(_delta):
	if update_speed == 1:
		render_target_update_mode = SubViewport.UPDATE_ALWAYS
		get_parent().get_parent().DrawDesktop()
	else:
		cnt += 1
		cnt %= update_speed
		if cnt == 0:
			render_target_update_mode = SubViewport.UPDATE_ONCE
		elif cnt == update_speed/2:
			get_parent().get_parent().DrawDesktop()
	
