extends CharacterBody2D
@onready var playergui =$"../CanvasLayer/PlayerGUi"
const MaxVelocity_X = 600
@onready var Camera = $"../Camera2D"
const MaxGravity = -40
var isDashing = false
var AllowedToDash = true
@export var Health = 100
@onready var World = $".."
@onready var RayCast =  $RayCast2D
@onready var PlayerArea = $PlayerArea
var deathscreen = preload("res://Deathscene.tscn")
var deathparticle = preload("res://Deadparticle.tscn")
var dead = false
var OnWall = false
var Gravity = 30
var Knockback = false
var Stunned = false
func _ready() -> void:
	PlayerArea.area_entered.connect( func (area): 
		if area.is_in_group("Wall") and  not self.is_on_floor() :
			OnWall = true 
			self.velocity.y = 0)
	PlayerArea.area_exited.connect(func (area): OnWall = false)
func _physics_process(delta: float) -> void:
	if dead:
		self.velocity = Vector2.ZERO
		move_and_slide()
		return
	if is_on_floor():
		if not isDashing:
			AllowedToDash = true
		if OnWall:
			OnWall = false
	var axis = Input.get_axis("ui_left","ui_right")
	if Stunned:axis = 0
	if not isDashing   :
		if not Knockback:
			if OnWall:
				Gravity = 5
			else:
				Gravity = 30		  
			self.velocity.y = move_toward(self.velocity.y,1000 ,Gravity * delta * 60) 
			self.velocity.x = move_toward(self.velocity.x,MaxVelocity_X * axis,50 * delta * 60) 
	else:
		if Knockback :
			isDashing = false
		else:
			Dash(delta)
	if Input.is_action_just_pressed("ui_accept"):
		if self.is_on_floor():
			self.velocity.y = -900  
		elif OnWall:	
			var PositiveOrNegative = -1
			if RayCast.is_colliding():
				PositiveOrNegative = 1
			self.velocity = Vector2(PositiveOrNegative *  900,-1000)
			OnWall = false
	if Input.is_action_just_pressed("Dash") and  not isDashing and AllowedToDash and not Stunned:
		print("run")
		if OnWall :
			if RayCast.is_colliding():
				axis = 1
			else:
				axis = -1	
		elif axis == 0:
			axis = 1
		self.velocity.x = 2000 * axis
		self.velocity.y = 0
		isDashing = true
	move_and_slide()
	Camera.position = self.position
	pass
func Dash(delta) ->void:
	AllowedToDash = false
	self.velocity.y = 0
	self.velocity.x = move_toward(self.velocity.x,0, 4500 *delta)
	print(self.velocity.x)
	if self.velocity.x == 0:
		print("done")
		isDashing = false
	
func playerKnockBackStun(direction,Strengh):
	if not Stunned:
		Stunned = true
		Knockback = true
		print("wow")
		self.velocity = direction * Strengh
		await  get_tree().physics_frame
		Knockback = false
		await get_tree().create_timer(0.1).timeout
		Stunned = false
func playerKnockBack(direction,Strengh):
		Knockback = true
		print("wow")
		self.velocity = direction * Strengh
		await  get_tree().physics_frame
		Knockback = false
func  GetDamage(Amount):
	Health -= Amount
	if Health <= 0:
		Kill()
func Kill():
	self.Health = 0
	if dead:return
	dead = true
	var clone = deathscreen.instantiate()
	var particle = deathparticle.instantiate()
	clone.process_mode = Node.PROCESS_MODE_ALWAYS
	particle.position = self.position
	World.call_deferred("add_child",particle)
	var particleEmitter:CPUParticles2D = particle.get_node("CPUParticles2D")
	%ColorRect.visible = false
	await  get_tree().create_timer(0.5).timeout
	particleEmitter.emitting = false
	await  get_tree().create_timer(0.5).timeout
	World.add_child(clone)
	World.set_deferred("process_mode",Node.ProcessMode.PROCESS_MODE_DISABLED)
	


	
	
	
