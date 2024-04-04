extends Node3D

@onready var anim_player := $AnimationPlayer

enum ANIMATIONS {STAND,SLEEP,SIT_ON_DESK,START}

var now_playing :ANIMATIONS = ANIMATIONS.START


func play(a:ANIMATIONS):
	if a == ANIMATIONS.START:
		anim_player.play("start")
		position = Vector3(1.1,0,2.3)
		rotation_degrees = Vector3(0,30,0)
	elif a == ANIMATIONS.STAND:
		anim_player.play("stand")
		position = Vector3(0,0,-3.0)
		rotation_degrees = Vector3(0,160,0)
	elif a == ANIMATIONS.SIT_ON_DESK:
		anim_player.play("sin_on_desk")
		position = Vector3(-0.35,0,0.75)
		rotation_degrees = Vector3(0,90,0)
	else:
		anim_player.play("sleep")
		position = Vector3(-0.5,0,-1.0)
		rotation_degrees = Vector3(0,90,0)
	
	now_playing = a

func _ready():
	Config.configs["Wallpaper:visible"].on_change(func(_v):check_show())
	Config.configs["ARONA:visible"].on_change(func(_v):check_show())
	Config.configs["Wallpaper:charactor"].on_change(func(_v):check_show())

func check_show():
	if Config.configs["Wallpaper:visible"].value and Config.configs["Wallpaper:charactor"].value and !Config.configs["ARONA:visible"].value :
		visible = true
		anim_player.stop()
		play(ANIMATIONS.START)
	else:
		visible = false

func _on_animation_finished(anim_name):
	if anim_name == "start" or randf_range(0, 100) < 12.0:
		var temp := randf_range(0, 3)
		if temp < 1.0:
			now_playing = ANIMATIONS.STAND
		elif temp < 2.0:
			now_playing = ANIMATIONS.SLEEP
		else:
			now_playing = ANIMATIONS.SIT_ON_DESK
	play(now_playing)
