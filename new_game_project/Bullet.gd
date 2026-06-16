extends CharacterBody2D
var speed =60000
var direction = false
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
		get_tree().create_timer(3).timeout.connect(func():self.queue_free())


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	if direction:
		self.velocity = speed * direction * delta
	move_and_slide()

func launch(directionGiven:Vector2):
	direction = directionGiven
