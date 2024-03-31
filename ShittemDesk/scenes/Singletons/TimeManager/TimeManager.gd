extends Node

var year: int
var month : int
var weekday : int
var day: int
var hour : int
var minute : int
var second :int

func set_now():
	var time_dict := Time.get_datetime_dict_from_system()
	year = time_dict["year"]
	month = time_dict["month"]
	weekday = time_dict["weekday"]
	day = time_dict["day"]
	hour = time_dict["hour"]
	minute = time_dict["minute"]
	second = time_dict["second"]

func _init():
	set_now()
func _on_timer_timeout():
	set_now()
	for t in Config.configs["General:notify_time"].value:
		if t[0] != -1 and t[0] != year:continue
		if t[1] != -1 and t[1] != month:continue
		if t[2] != -1 and t[2] != day:continue
		if t[3] != -1 and t[3] != hour:continue
		if t[4] != -1 and t[4] != minute:continue
		if t[5] != -1 and t[5] != second:continue
		BubbleWindow.speak(t[6])
