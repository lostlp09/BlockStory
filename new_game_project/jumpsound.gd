extends AudioStreamPlayer2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	self.volume_db = -100 + SaveStats.PlayerData["Volume"]
	self.play()
	pass # Replace with function body.
	self.finished.connect(func():
		self.queue_free()
		)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
