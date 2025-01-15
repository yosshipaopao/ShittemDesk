extends Node

const app_id = 1217789623149924422

var state = true

func _ready():
	DiscordRPC.app_id = app_id
	DiscordRPC.details = "アロナが先生のサポートをしています！"
	DiscordRPC.state = ""
	
	DiscordRPC.large_image = "icon"
	DiscordRPC.large_image_text = "すーぱーえーあいアロナちゃん！"
	DiscordRPC.start_timestamp = int(Time.get_unix_time_from_system())
	
	DiscordRPC.refresh()
	
	Config.configs["General:Discord"].on_change(func(v:int):
		if v == 1 or v==2:
			if v== 1:
				DiscordRPC.state = ""
			else:
				DiscordRPC.state = GlobalMediaSession.get_media_title()	
			DiscordRPC.refresh()
			if not state:
				restart()
				state = true
		else:
			stop()
			state = false
		)
	
	GlobalMediaSession.song_changed.connect(func():
		if Config.configs["General:Discord"].value == 2:
			DiscordRPC.state = "再生中：" + GlobalMediaSession.get_media_title()
			DiscordRPC.refresh()
		)

func _process(_delta):
	DiscordRPC.run_callbacks()

func update_state(_state:String):
	DiscordRPC.state = _state
	DiscordRPC.refresh()

func stop():
	DiscordRPC.clear()

func restart():
	DiscordRPC.unclear()
