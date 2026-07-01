extends Node2D

@onready var Pan = $Panel
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var originalPanelSize = Pan.size
	var originalPanelPos = Pan.position
	var timer = get_tree().create_timer(0.5,false)
	while  timer.time_left != 0:
		if not is_inside_tree():return
		print(timer.time_left)
		var returnValue =  (1 - sigmoid(1- 2*timer.time_left))
		Pan.size.y = returnValue * originalPanelSize.y
		Pan.position.y = returnValue * originalPanelPos.y
		await get_tree().process_frame
	self.queue_free()
		

	
func sigmoid(x) -> float:
	return 	1/(1+exp(-x*7)) *2 -1 
		
	
