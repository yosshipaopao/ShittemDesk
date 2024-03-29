extends Control

# Dictionay of Live2DModel
var Charactors := {
	"Default" : "res://assets/Live2d/Prana/prana.model3.json",
	"Picked" : "res://assets/Live2d/つままれPrana/つままれprana.model3.json",
}
func _ready():
	preload("res://assets/Live2d/Prana/prana.model3.json")
	preload("res://assets/Live2d/つままれPrana/つままれprana.model3.json")
@onready var model := $Model
# WindowSize of window when size = 100%
var window_sizes := {
	"Default": Vector2(200,450),
	"Picked" : Vector2(200,500)
}
# Key of the displayed model
@export_enum("Default","Picked") var now := "Default" :
	get:
		return now
	set(v):
		model.assets = Charactors[v]
		model.position = window_sizes[v] / 2
		PranaWindow.window_base_size = window_sizes[v]
		now = v
# watch models Vector2 (-1,-1) ~ (1,1)
func watch(v:Vector2) -> void:
	model.watch(v)
# change halo
func halo(i:int) -> void:
	model.halo = i
	
func motion(group:String,state:int):
	model.motion(group,state)
	
func expression(group:String,state:int):
	model.expression(group,state)
