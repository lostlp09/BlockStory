extends Control

var SettingsMenue = preload("res://Settings.tscn")
var InputMenue = preload("res://inputSettings.tscn")
var Credit = preload("res://Credits.tscn")
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	%PlayButton.pressed.connect(func():get_tree().change_scene_to_file("res://node_2d.tscn"))
	%DeleteData.pressed.connect(func():SaveStats.DeleteData())
	%Settingsbutton.pressed.connect(func():
		var Clone = SettingsMenue.instantiate()
		self.add_child(Clone)
		get_tree().paused = true
		)
	%InputButton.pressed.connect(LoadInput)
	%Credits.pressed.connect(LoadCredits)
	var tween = self.create_tween()
	tween.tween_property(%Title,"scale",Vector2(0.2,0.2),0.5).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
	tween.tween_interval(2)
	tween.parallel().tween_property(%PlayButton,"position",%PlayButton.position + Vector2(0,600),1).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
	tween.parallel().tween_property(%Settingsbutton,"position",%Settingsbutton.position + Vector2(0,600),1).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
	tween.parallel().tween_property(%DeleteData,"position",%DeleteData.position + Vector2(0,600),1).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
	tween.parallel().tween_property(%Credits,"position",%Credits.position + Vector2(0,600),1).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
	tween.parallel().tween_property(%InputButton,"position",%InputButton.position + Vector2(0,600),1).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func LoadInput():
	var Instance = InputMenue.instantiate()
	self.add_child(Instance)
	get_tree().paused = true
func LoadCredits():
	var Instance = Credit.instantiate()
	self.add_child(Instance)
	get_tree().paused = true
	
