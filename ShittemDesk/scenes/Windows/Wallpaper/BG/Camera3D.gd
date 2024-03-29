extends Camera3D

var tween: Tween
var default_rotation := rotation
var weight := 0.005
func _process(_delta):
	if randi_range(0,20) == 20:
		if tween:
			tween.kill()
		tween = create_tween()
		tween.tween_property(self,"rotation",default_rotation+Vector3(randf_range(-weight, weight),randf_range(-weight, weight),randf_range(-weight,weight)),1)		
		tween.play()
