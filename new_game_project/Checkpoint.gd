extends Area2D

@export var Checkpoint = 1


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if Checkpoint > SaveStats.PlayerData["Checkpoint"]:
		self.body_entered.connect(createTween)
	else:
		%ColorRect.color = Color.hex(0xade8f4)
		


func  createTween():
	var tween = get_tree().create_tween()
	tween.tween_property(%ColorRect,"color",Color.hex(0xade8f4),0.5)
	tween.set_ease(Tween.EASE_IN)
	tween.play()
	self.body_entered.disconnect(createTween)
	SaveStats.PlayerData["Checkpoint"] = Checkpoint
	
