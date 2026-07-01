extends CanvasLayer

@onready var slider = %HSlider
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if self.get_parent().name == "Menue":
		pass
		$ColorRect/GoBackTOMenue.disabled = true
		$ColorRect/GoBackTOMenue.visible = false
	else:
		%GoBackTOMenue.pressed.connect(func():
			get_tree().paused = false
			get_tree().change_scene_to_file("res://Menue.tscn")
			)
	var tween = create_tween()
	tween.tween_property(%ColorRect,"scale",Vector2(1,1),0.3).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
	slider.value = SaveStats.PlayerData["Volume"]
	pass # Replace with function body.
	%Exit.pressed.connect(func ():
		get_tree().paused = false
		SaveStats.SaveData()
		self.queue_free())

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	SaveStats.PlayerData["Volume"] = slider.value
	%Value.text = var_to_str(slider.value)
	pass
