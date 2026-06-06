extends CharacterBody2D
var velocity_Y = 0
const MaxVelocity_X = 300
@onready var Camera = $"../Camera2D"
const MaxGravity = -40
var isDashing = false
var AllowedToDash = true
@onready var RayCast =  $RayCast2D
@onready var PlayerArea = $PlayerArea
var OnWall = false
var Gravity = 30
func _ready() -> void:
	PlayerArea.area_entered.connect( func (area): 
		if area.is_in_group("Wall") and  not self.is_on_floor() :
			OnWall = true 
			self.velocity.y = 0)
	PlayerArea.area_exited.connect(func (area): OnWall = false)
	
	pass # Replace with function body.
func _physics_process(delta: float) -> void:
	print(OnWall)
	if is_on_floor():
		if not isDashing:
			AllowedToDash = true
		if OnWall:
			OnWall = false
	var axis = Input.get_axis("ui_left","ui_right")
	
	if not isDashing :
		if OnWall:
			Gravity = 5
		else:
			Gravity = 30
						  
		self.velocity.y =move_toward(self.velocity.y,3000,Gravity) * delta * 60 
		self.velocity.x = move_toward(self.velocity.x,MaxVelocity_X * axis,50) * delta * 60 
		
		
	else:
		Dash(delta)
	
	if Input.is_action_just_pressed("ui_accept"):
		
		if self.is_on_floor():
			self.velocity.y = -900  
		elif OnWall:
			var PositiveOrNegative = -1
			if RayCast.is_colliding():
				PositiveOrNegative = 1
			self.velocity = Vector2(PositiveOrNegative *  800,-800)
			OnWall = false
			
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
