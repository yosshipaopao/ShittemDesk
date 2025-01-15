extends MediaSession

var _seek := 0
var _diff := 0
var duration := 0

var title :String

@onready var timer := $Timer


func _ready():
	var s := get_seek()
	duration = s[0]
	_seek = s[1]
	get_tree().root.connect("ready",func():song_changed.emit())
	title = get_media_title()

func _process(delta):
	var _s_now := get_seek()
	var _seek_now :int = _s_now[1]
	if duration != _s_now[0]:
		song_changed.emit()
		duration = _s_now[0]
	if _seek == _seek_now:
		if is_playing:
			_diff += int(delta*(10**7))
	else:
		_seek = _seek_now
		_diff = 0

signal song_changed()

var seek : int :
	get:
		return _seek + _diff
	set(v):
		set_seek(v)
var is_playing : bool :
	get:
		return get_status() == 4
	set(v):
		if v:
			play_media()
		else:
			pause_media()


func _on_timer_timeout():
	var new_title := get_media_title()
	if title != new_title:
		title = new_title
		song_changed.emit()
