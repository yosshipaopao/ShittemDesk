@tool
class_name AnimatedButton
extends Button

var tween : Tween
func _ready() -> void:pivot_offset = size / 2
@export var press_scale : float = 0.9
@export var press_animation_duration : float = 0.1

func _on_button_down() -> void:
	if tween:
		tween.kill()
	tween = create_tween()
	tween.set_ease(Tween.EASE_IN)
	tween.tween_property(self,"scale",Vector2.ONE*press_scale,press_animation_duration)
	tween.play()
func _on_button_up() -> void:
	if tween:
		tween.kill()
	tween = create_tween()
	tween.set_ease(Tween.EASE_OUT)
	tween.tween_property(self,"scale",Vector2.ONE,press_animation_duration)
	tween.play()
