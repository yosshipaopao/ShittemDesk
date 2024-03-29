extends VBoxContainer


var Item := preload("res://scenes/Windows/SettingsWindow/General/TimeNotification/item.tscn")
func _ready():
	Config.configs["General:notify_time"].on_change(func(v):
		if v.size() != get_child_count(false):
				for n in get_children():
					remove_child(n)
					n.queue_free()
				var i:=0
				for n in v:
					var item = Item.instantiate()
					item.set_value(i,n[0],n[1],n[2],n[3],n[4],n[5],n[6])
					item.on_value_changed.connect(update_value)
					item.delete_requested.connect(delete_value)
					add_child(item)
					i+=1
		else:
			for i in range(v.size()):
				var j:=get_child(i)
				var n = v[i]
				j.set_value(i,n[0],n[1],n[2],n[3],n[4],n[5],n[6])
				j.update_value()
		)
func update_value(index:int,value:Array):
	Config.configs["General:notify_time"].value[index] = value
	Config.configs["General:notify_time"].value = Config.configs["General:notify_time"].value
func delete_value(index:int):
	Config.configs["General:notify_time"].value.pop_at(index)
	Config.configs["General:notify_time"].value = Config.configs["General:notify_time"].value


func _on_animated_button_pressed():
	Config.configs["General:notify_time"].value.append([-1, -1, -1, -1, 0, 0, "アロナが一時間毎に時刻をお知らせします！"])
	Config.configs["General:notify_time"].value = Config.configs["General:notify_time"].value
