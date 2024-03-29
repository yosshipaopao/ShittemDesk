@tool
class_name TimeNotificationSettingItem
extends Control

var index:int

var _year:int
var _month:int
var _date:int
var _hour:int
var _minute:int
var _second:int
var _selif:String

func set_value(_index:int=0,__year:int=-1,__month:int=-1,__date:int=-1,__hour:int=-1,__minute:int=0,__second:int=0,__selif:String=""):
	index = _index
	_year = __year
	_month = __month
	_date = __date
	_hour = __hour
	_minute = __minute
	_second = __second
	_selif = __selif

func update_value():
	ok_emit= false
	year = _year
	month = _month
	date = _date
	hour = _hour
	minute = _minute
	second = _second
	selif = _selif
	ok_emit = true

func _ready():
	update_value()

var ok_emit := false

signal on_value_changed(index:int,v:Array)
signal delete_requested(index:int)

func emit_value_changed():
	if ok_emit:
		on_value_changed.emit(index,[year,month,date,hour,minute,second,selif])

@export var year :int :
	set(v):
		if $HBoxContainer/Year.value != v:
			$HBoxContainer/Year.value = v
			year=v
			emit_value_changed()
func _on_year_value_changed(value):
	year = int(value)
@export var month :int:
	set(v):
		if $HBoxContainer/Month.value != v:
			$HBoxContainer/Month.value = v
			month=v
			emit_value_changed()
func _on_month_value_changed(value):
	month = int(value)
@export var date :int:
	set(v):
		if $HBoxContainer/Date.value != v:
			$HBoxContainer/Date.value = v
			date = v
			emit_value_changed()
func _on_date_value_changed(value):
	date = int(value)
@export var hour :int:
	set(v):
		if $HBoxContainer/Hour.value != v:
			$HBoxContainer/Hour.value = v
			hour = v
			emit_value_changed()
func _on_hour_value_changed(value):
	hour = int(value)
@export var minute :int:
	set(v):
		if $HBoxContainer/Minute.value != v:
			$HBoxContainer/Minute.value = v
			minute=v
			emit_value_changed()
func _on_minute_value_changed(value):
	minute = int(value)
@export var second :int:
	set(v):
		if $HBoxContainer/Second.value != v:
			$HBoxContainer/Second.value = v
			second=v
			emit_value_changed()
func _on_second_value_changed(value):
	second = int(value)
@export var selif :String = "":
	set(v):
		if $Control/Serif.text!=v:
			$Control/Serif.text = v
			selif = v
			emit_value_changed()
func _on_serif_text_changed(new_text):
	selif = new_text

func _on_animated_button_pressed():
	delete_requested.emit(index)
