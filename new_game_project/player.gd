extends CharacterBody2D
var velocity_Y = 0
const MaxVelocity_X = 300
@onready var Camera = $"../Camera2D"
const MaxGravity = -40
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


func _physics_process(delta: float) -> void:
	self.velocity.y = move_toward(self.velocity.y,300,20)
	if Input.is_action_just_pressed("ui_accept") and self.is_on_floor():
		self.velocity.y = -700
	var axis = Input.get_axis("ui_left","ui_right")
	self.velocity.x = move_toward(self.velocity.x,MaxVelocity_X * axis,50)
	print(axis)
	print(self.velocity)
	move_and_slide()
	Camera.position = self.position
	pass
