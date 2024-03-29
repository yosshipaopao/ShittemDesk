extends Button



func _on_pressed():
	var output :Array[String]= []
	OS.execute("CMD.exe",["/C","echo", "%appdata%"],output)
	var lnk := output[0].substr(0,output[0].length() - 2) + "\\" + String(ProjectSettings.get_setting("application/config/name"))
	
	OS.create_process("explorer.exe",[lnk])
