extends CharacterBody2D
var velocity_Y = 0
const MaxVelocity_X = 300
@onready var Camera = $"../Camera2D"
const MaxGravity = -40
var isDashing = false
var AllowedToDash = true
func _ready() -> void:
	pass # Replace with function body.
func _physics_process(delta: float) -> void:
	
	if is_on_floor():
		if not isDashing:
			AllowedToDash = true
	var axis = Input.get_axis("ui_left","ui_right")
	
	if not isDashing :
		self.velocity.y = clamp(self.velocity.y + 30 ,-99999,3000) * delta * 60 
		self.velocity.x = move_toward(self.velocity.x,MaxVelocity_X * axis,50) * delta * 60 
	else:
		Dash(delta)
	
	if Input.is_action_just_pressed("ui_accept") and self.is_on_floor():
		self.velocity.y = -900  
	
	if Input.is_action_just_pressed("Dash") and  not isDashing and axis != 0 and AllowedToDash:
		self.velocity.x = 2000 * axis
		self.velocity.y = 0
		isDashing = true
	move_and_slide()
	Camera.position = self.position
	pass
func Dash(delta) ->void:
	AllowedToDash = false
	self.velocity.x = move_toward(self.velocity.x,0, 4500 *delta)
	print(self.velocity.x)
	if self.velocity.x == 0:
		print("done")
		isDashing = false
	


	
	
	
	
func Beam() ->void:
	pass	
