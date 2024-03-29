@tool
extends Node3D

const day_length := 60 * 60 * 24
@export_category("Time")
@export var day_speed :float = 1.0
# 0 ~ 60 * 60 * 24
@export var time : float = 0 :
	set(v):time = v - day_length * int(v / day_length)
var _time : float :
	get:return time / day_length
	set(v):time = v * 60 * 60 * 24

@export_category("Sun")
@export var max_sun_altitude : float = 60.0
@export var sun_color : Gradient = Gradient.new()
@export var sun_strength : Curve = Curve.new()
@export_category("Moon")
@export var max_moon_altitude : float = 60.0
@export var moon_color : Gradient = Gradient.new()
@export var moon_strength : Curve = Curve.new()

@onready var world_environment := $WorldEnvironment
@onready var sun_rotate_X := $sun_rotate_x
@onready var sun := $sun_rotate_x/Sun
@onready var moon_rotate_X := $moon_rotate_x
@onready var moon := $moon_rotate_x/Moon

func _process(delta):
	time += delta * day_speed
	var __time = _time + 0.5
	if __time > 1.0:__time -= 1.0
	# sun
	sun_rotate_X.rotation_degrees.x = max_sun_altitude
	sun.rotation_degrees.y = _time * 360
	sun.light_color = sun_color.sample(_time)
	sun.light_energy = sun_strength.sample(_time)
	#sun.visible = sun.light_energy > 0
	# moon
	moon_rotate_X.rotation_degrees.x = max_moon_altitude
	moon.rotation_degrees.y = __time * 360
	moon.light_color = moon_color.sample(__time)
	moon.light_energy = moon_strength.sample(__time)
	#moon.visible = moon.light_energy > 0
	
	world_environment.environment.sky.sky_material.set_shader_parameter("time",_time)
