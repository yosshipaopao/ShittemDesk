extends Node

const app_id = 1217789623149924422

var state = true

func _ready():
	DiscordSDK.app_id = app_id
	DiscordSDK.details = "アロナが先生のサポートをしています！"
	DiscordSDK.state = ""
	
	DiscordSDK.large_image = "icon"
	DiscordSDK.large_image_text = "すーぱーえーあいアロナちゃん！"
	DiscordSDK.start_timestamp = int(Time.get_unix_time_from_system())
	
	DiscordSDK.refresh()
	
	Config.configs["General:Discord"].on_change(func(v:int):
		if v == 1 or v==2:
			if v== 1:
				DiscordSDK.state = ""
			else:
				DiscordSDK.state = GlobalMediaSession.get_media_title()	
			DiscordSDK.refresh()
			if not state:
				restart()
				state = true
		else:
			stop()
			state = false
		)
	
	GlobalMediaSession.song_changed.connect(func():
		if Config.configs["General:Discord"].value == 2:
			DiscordSDK.state = "再生中：" + GlobalMediaSession.get_media_title()
			DiscordSDK.refresh()
		)

func _process(_delta):
	DiscordSDK.run_callbacks()

func update_state(_state:String):
	DiscordSDK.state = _state
	DiscordSDK.refresh()

func stop():
	DiscordSDK.clear()

func restart():
	DiscordSDK.unclear()
