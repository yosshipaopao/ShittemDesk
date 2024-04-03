extends Node
var config_file := ConfigFile.new()
const user := "user"
const config_path := "user://config.cfg"

@export var _configs : Dictionary = {
	"AgreedToTermsOfUse" : false,
	"General:FPS" : 60 ,
	"General:Discord": 1,
	"General:notify_time" : [],
	"General:check_latest": true,
	"ARONA:visible" : false ,
	"ARONA:size" : 100 ,
	"ARONA:position" : Vector2i.ZERO ,
	"PRANA:visible" : false ,
	"PRANA:size" : 100 ,
	"PRANA:position" : Vector2i.ZERO ,
	"Wallpaper:visible" : false,
	"Wallpaper:day_speed" : 1 ,
	"Wallpaper:update_speed" : 4,
}

class _Config:
	var config_file : ConfigFile
	var key : String
	var _value 
	var value :
		get:return _value
		set(v):
			_value  = v
			on_value_changed.emit(v)
			save()
	signal on_value_changed(v)
	
	func _init(_config_file : ConfigFile , _key: String , _default_value ):
		config_file = _config_file
		key = _key
		_value = config_file.get_value(user , key , _default_value)
	
	func on_change(f:Callable) -> void:
		on_value_changed.connect(f)
	func default() -> void:
		on_value_changed.emit(value)
	
	
	func save()	:
		config_file.set_value(user,key,value)
		config_file.save(config_path)

var configs := Dictionary()

func new_config(key:String,default_value):
	configs[key] = _Config.new(config_file,key,default_value)

func reset():
	config_file.clear()
	config_file.save(config_path)
	for k in _configs.keys():
		configs[k].default()

func _init():
	config_file.load(config_path)
	for k in _configs.keys():
		new_config(k,_configs[k])

func _ready():
	get_tree().root.ready.connect(func():
		for k in _configs.keys():
			configs[k].default()
		)
