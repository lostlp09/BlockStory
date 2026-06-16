extends Node2D

var speed = 700
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var createTimer = get_tree().create_timer(2)
	$Left.body_entered.connect(PlayerHit.bind($Left))
	$Right.body_entered.connect(PlayerHit.bind($Right))
	while not createTimer.time_left  <=0:
		if $Left:
			$Left.position.x -= speed * get_physics_process_delta_time() 
		if $Right:
			$Right.position.x +=  speed * get_physics_process_delta_time() 
		await  get_tree().physics_frame
	self.queue_free()
	
func PlayerHit(Body,object):
	if Body.is_in_group("player"):
		Body.GetDamage(10)
		object.queue_free()
		print(Body.Health)
