extends Sprite2D

var wasin = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass
# Called every frame. 'delta' is the elapsed time since the previous frame
func bodyentered(Body):
	if Body.is_in_group("player") and not wasin:
		wasin = true
		Body.GetDamage(10)

func launch(Hight):
	var OldHight = Hight
	var timer = get_tree().create_timer(1)
	while  timer.time_left > 0 :
			self.position.y =  ease(1- timer.time_left,0.2) * -100+ OldHight
			await  get_tree().process_frame
	self.position.y = OldHight -100
	OldHight = self.position.y
	timer = get_tree().create_timer(1)
	while  timer.time_left > 0 :
		self.position.y =  ease(1- timer.time_left,0.2) * 100 +OldHight
		await  get_tree().process_frame
	self.position.y = OldHight +100
	self.queue_free()
