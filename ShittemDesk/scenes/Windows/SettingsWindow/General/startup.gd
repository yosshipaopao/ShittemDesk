extends Panel

func _on_button_pressed():
	var output :Array[String]= []
	OS.execute("CMD.exe",["/C","echo", "%appdata%"],output)
	var lnk := output[0].substr(0,output[0].length() - 2) + "\\Microsoft\\Windows\\Start Menu\\Programs\\Startup\\" + String(ProjectSettings.get_setting("application/config/name"))
	var app := OS.get_executable_path()
	var cmd := "mklink \"" + lnk + "\" " + "\"" + app + "\""
	var output2 = []
	OS.execute("CMD.exe",["/C",cmd],output2)
	
