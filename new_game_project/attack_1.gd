extends Node2D
@onready var texture:Sprite2D = $Sprite2D
func sigmoid(x) -> float:
	return 	1/(1+exp(-x*7)) *2 -1
		
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	%AudioStreamPlayer2D.volume_db = -100 +SaveStats.PlayerData["Volume"]
	var timer  = get_tree().create_timer(0.5)
	await  get_tree().process_frame

	var currentRotation = self.rotation_degrees
	var GoalRotation  = currentRotation +90
	while timer.time_left != 0 :
		if not get_tree():return
		var calculation = sigmoid(1 - timer.time_left * 2)
		texture.modulate.a = 1-calculation
		self.rotation_degrees =  currentRotation + 90* calculation
		await get_tree().process_frame
	print("done")
	self.queue_free()
# Called every frame. 'delta' is the elapsed time since the previous frame.

	
