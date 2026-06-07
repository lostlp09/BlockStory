extends Node2D

@onready var Pan = $Panel
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var originalPanelSize = Pan.size
	var originalPanelPos = Pan.position
	var index = 0
	while  Pan.size.y > 0.1:
		index += 0.04  
		var returnValue =  (1 - sigmoid(index))
		Pan.size.y = returnValue * originalPanelSize.y
		Pan.position.y = returnValue * originalPanelPos.y
		await get_tree().create_timer(0.01).timeout
	self.queue_free()
		

	
func sigmoid(x) -> float:
	return 	1/(1+exp(-x*7)) *2 -1 
		
	
