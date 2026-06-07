extends Node2D
@onready var texture:Sprite2D = $Sprite2D
func sigmoid(x) -> float:
	return 	1/(1+exp(-x*7)) *2 -1
		
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var index = 0
	await  get_tree().process_frame

	var currentRotation = self.rotation_degrees
	var GoalRotation  = currentRotation +90
	print("test")
	print(self.rotation_degrees)
	print(GoalRotation)
	while self.rotation_degrees < GoalRotation -0.1:
		var calculation = sigmoid(index)
		index += 0.03
		texture.modulate.a = 1-calculation
		self.rotation_degrees =  currentRotation + 90* calculation
		await get_tree().process_frame
	print("done")
	self.queue_free()
# Called every frame. 'delta' is the elapsed time since the previous frame.

	
