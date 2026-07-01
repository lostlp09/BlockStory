extends Area2D

@export var Checkpoint = 1


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if Checkpoint > SaveStats.PlayerData["Checkpoint"]:
		self.body_entered.connect(createTween)
		
	else:
		print("Your currentCheckpoint is  ",SaveStats.PlayerData["Checkpoint"],Checkpoint)
		self.set_process(false)
		%ColorRect.color = Color.hex(0xade8f4)
		
func _process(delta: float) -> void:
	if Checkpoint <= SaveStats.PlayerData["Checkpoint"]:
		print("Your currentCheckpoint is  ",SaveStats.PlayerData["Checkpoint"],Checkpoint)
		%ColorRect.color = Color.hex(0xade8f4)
		self.set_process(false)
		
func  createTween(body):
	if body.is_in_group("player"):
		var tween = get_tree().create_tween()
		%Player.Health  = 100
		tween.tween_property(%ColorRect,"color",Color.hex(0xade8f4),0.5)
		tween.set_ease(Tween.EASE_IN)
		tween.play()
		self.body_entered.disconnect(createTween)
		SaveStats.PlayerData["Checkpoint"] = Checkpoint
		SaveStats.SaveData()
		var CheckpointSoundEffect = preload("res://checkpoint_sound.tscn")
		var clone = CheckpointSoundEffect.instantiate()
		self.add_child(clone)
		
