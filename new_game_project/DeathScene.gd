extends CanvasLayer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:

	%ReplayButton.pressed.connect(func():
		get_tree().set_deferred("paused",false)
		get_tree().change_scene_to_file("res://node_2d.tscn"))
	var tween = self.create_tween()
	tween.tween_property(%Control,"scale",Vector2(1,1),0.3).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
	tween.play()
	await get_tree().create_timer(0.4).timeout
	%ReplayButton.disabled = false
	get_tree().set_deferred("paused",false)
