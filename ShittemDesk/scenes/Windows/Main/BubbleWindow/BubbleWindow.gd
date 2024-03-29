extends Window

@onready var base := $Control
@onready var timer := $Timer
func speak(t:String):
	if Config.configs["ARONA:visible"].value or Config.configs["PRANA:visible"].value:
		visible = true
		base.speak(t)
		timer.start()
func _on_timer_timeout():visible=false
func _process(_delta):
	if visible:
		if Config.configs["ARONA:visible"].value:		
			position = AronaWindow.position - Vector2i((size.x - AronaWindow.size.x)/2,-AronaWindow.size.y/3)
		elif Config.configs["PRANA:visible"].value:
			position = PranaWindow.position - Vector2i((size.x - PranaWindow.size.x)/2,-PranaWindow.size.y/3)
		else:
			visible = false
