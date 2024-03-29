@tool
class_name Live2DModel
extends Sprite2D

@export_category("Models")
# model3.json's path
@export_file("*.model3.json") var assets := "" :
	set(v):
		assets = v
		$GDCubismUserModel.assets = v
@export var halo_idx := -1
@export_category("state")
@export var halo := 0
@export_category("Debug")
@export var breath : bool = true :
	set(v):
		breath = v
		$GDCubismUserModel/GDCubismEffectBreath.active = v
@export var eye_blink : bool = true :
	set(v):
		eye_blink = v
		$GDCubismUserModel/GDCubismEffectEyeBlink.active = v
@export var target_point_active : bool = true :
	set(v):
		target_point_active = v
		$GDCubismUserModel/GDCubismEffectTargetPoint.active = v
@export_enum("FULL","NONE") var parameter_mode := "FULL" :
	set(v):
		parameter_mode = v
		$GDCubismUserModel.parameter_mode = parameter_mode_int
var parameter_mode_int : int :
	get:
		if parameter_mode == "FULL":
			return GDCubismUserModel.FULL_PARAMETER
		else:
			return GDCubismUserModel.NONE_PARAMETER
# GDCubismUserModel
@onready var model :GDCubismUserModel = $GDCubismUserModel
# GDCubismEffectTargetPoint
@onready var target_point := $GDCubismUserModel/GDCubismEffectTargetPoint
# GDCubismEffectTargetPoint.set_target
func watch(t:Vector2) -> void:target_point.set_target(t)
# change halo

# data of max_durations of motion
@export var motion_durations := {
}
# save last state or default
var last_motion := {
}
var motion_queues_num : Dictionary = {
}
# state if motion is runnning or not
var motion_state := false
# motion queues
var motion_queues :Array[Array]= []
# GDCubismUserModel.start_motion
func motion(group:String,state:int) -> void:
	# add motion queues
	if last_motion[group] != state and motion_queues_num[group] < 3:
		motion_queues_num[group] += 1
		last_motion[group] = state
		motion_queues.append([group,state])
	
@export var expression_dict := {
	"Face":["Face00","Face01","Face02"],
}
var before_exp_ids := {
	"Face": "Face00"
}
func expression(group:String,no:int) -> void:
	var exp_id :String = expression_dict[group][no]
	if before_exp_ids[group] != exp_id:
		model.start_expression(exp_id)
		before_exp_ids[group] = exp_id

var _before_visible = true
func _process(_delta:float) -> void:
	if visible != _before_visible:
		RenderingServer.viewport_set_active(model.get_viewport_rid(),visible)
		_before_visible = visible
	if not motion_state and motion_queues.size() != 0:
		motion_state = true # set runnning
		var _motion :Array = motion_queues.pop_front() # get queue
		var group: String = _motion[0]
		var no: int = _motion[1]
		motion_queues_num[group] -= 1
		model.start_motion(group,no,GDCubismUserModel.PRIORITY_NORMAL)
		# wait duration
		await get_tree().create_timer(motion_durations[group][no]+0.03).timeout
		motion_state = false # set not runnning
	if halo_idx != -1 and model.get_parameters().size() > 0:
		model.get_parameters()[halo_idx].value = halo
### debug
# motions Dictionary
@onready var motions:Dictionary= model.get_motions()
func print_motions() -> void:
	var dict_motion = model.get_motions()
	for group in dict_motion.keys():
		for no in dict_motion[group]:
			print("group: %s, no: %d" % [group, no])
@onready var expressions : Array = model.get_expressions()
func print_expressions() -> void:
	for exp_id in expressions:
		print(exp_id)

func _ready() -> void:
	#print_motions()
	#print_expressions()
	pass
