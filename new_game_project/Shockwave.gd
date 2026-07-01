extends Node2D
@onready var left = $Left
@onready var Right = $Right
var speed = 700
var isready = false
var timer = null
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	self.process_mode = Node.PROCESS_MODE_INHERIT
	timer= get_tree().create_timer(2,false,false,false)
	isready = true
	$Left.body_entered.connect(PlayerHit.bind($Left))
	$Right.body_entered.connect(PlayerHit.bind($Right))
	
func  _physics_process(delta: float) ->void:
	if isready:
		if timer.time_left == 0 :self.queue_free()
		if left:
			left.position.x -= speed * delta
		if Right:
			Right.position.x +=  speed * delta
	
func PlayerHit(Body,object):
	if Body.is_in_group("player"):
		Body.GetDamage(10)
		object.queue_free()
		print(Body.Health)
