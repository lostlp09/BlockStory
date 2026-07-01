extends CharacterBody2D
@onready var playergui =$"../CanvasLayer/PlayerGUi"
const MaxVelocity_X = 600
@onready var Camera = $"../Camera2D"
const MaxGravity = -40
var isDashing = false
var AllowedToDash = true
var SettingsMenue = preload("res://Settings.tscn")
var DashSoundEffect = preload("res://dashSound.tscn")
@export var Health = 100
@onready var World = $".."
@onready var FakeRayCast:Area2D  = %FakeRaycast
@onready var PlayerArea = $PlayerArea
var deathscreen = preload("res://Deathscene.tscn")
var deathparticle = preload("res://Deadparticle.tscn")
var Jumsound = preload("res://jumpsound.tscn")
var dead = false
var OnWall = false
var Gravity = 40
var Knockback = false
var Stunned = false
var Clone = null
var Deathsound = preload("res://Death.tscn")
var hitsound = preload("res://hit_sound.tscn")
var Boss = false
var extrabstandoben = 0
func _ready() -> void:
	Health = SaveStats.Health
	if World.get_node("Map"):
		SaveStats.Health = 100
		Health =SaveStats.Health
		self.position = $"../Map/Checkpoint".get_child(SaveStats.PlayerData["Checkpoint"]).position
	else:
		extrabstandoben = -150
		Boss = %Boss
	PlayerArea.area_entered.connect( func (area): 
		if area.is_in_group("Wall") and  not self.is_on_floor() :
			AllowedToDash = true
			OnWall = true 
			self.velocity.y = 0)
	PlayerArea.area_exited.connect(func (area):
		if area.is_in_group("Wall"):
			OnWall = false)
func _physics_process(delta: float) -> void:
		
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
				Gravity = 40  
			self.velocity.y = move_toward(self.velocity.y,1000 ,Gravity * delta * 60) 
			
			self.velocity.x = move_toward(self.velocity.x,MaxVelocity_X * axis,90 * delta * 60) 
	else:
		if Knockback :
			isDashing = false
		else:
			Dash(delta)
	if Input.is_action_just_pressed("jump"):
		if self.is_on_floor():
			if not isDashing:
				var Instance =  Jumsound.instantiate()
				Instance.position = self.position
				World.add_child(Instance)
				self.velocity.y = -900  
		elif OnWall:	
			var Instance =  Jumsound.instantiate()
			Instance.position = self.position
			World.add_child(Instance)
			var PositiveOrNegative = -1
			if FakeRayCast.has_overlapping_bodies():
				print(FakeRayCast.get_overlapping_bodies())
				PositiveOrNegative = 1
			self.velocity = Vector2(PositiveOrNegative *  1000,-1000)
			OnWall = false
	if Input.is_action_just_pressed("Dash") and  not isDashing and AllowedToDash and not Stunned:
		var Clone = DashSoundEffect.instantiate()
		Clone.position = self.position
		World.add_child(Clone)
		if OnWall :
			if FakeRayCast.has_overlapping_bodies():
				print("goodJob")
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
func Dash(delta) ->void:
	AllowedToDash = false
	self.velocity.y = 0
	self.velocity.x = move_toward(self.velocity.x,0, 4500 *delta)
	print(self.velocity.x)
	if self.velocity.x == 0:
		print("done")
		isDashing = false
		if OnWall:
			AllowedToDash = true
	
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
	SaveStats.Health   -= Amount
	if Health <= 0:	
		Kill()
	else:
		##Color(0.0, 0.467, 0.714)
		var hitsoundIns = hitsound.instantiate()
		World.call_deferred("add_child",hitsoundIns)
		hitsoundIns.position = self.position
		var tween = self.create_tween()
		tween.tween_property(%ColorRect,"color",Color(0.986, 0.201, 0.0),0.2 )
		tween.tween_property(%ColorRect,"color",Color(0.0, 0.467, 0.714),0.1)
func Kill():
	self.Health = 0
	var Instance = Deathsound.instantiate()
	World.call_deferred("add_child",Instance)
	Instance.position = self.position
	self.set_deferred("process_mode",Node.PROCESS_MODE_DISABLED)
	if dead:return
	dead = true
	var clone = deathscreen.instantiate()
	var particle = deathparticle.instantiate()
	clone.process_mode = Node.PROCESS_MODE_ALWAYS
	particle.position = self.position
	World.call_deferred("add_child",particle)
	self.set_physics_process(false)
	var particleEmitter:CPUParticles2D = particle.get_node("CPUParticles2D")
	%ColorRect.visible = false
	await  get_tree().create_timer(0.5).timeout
	particleEmitter.emitting = false
	await  get_tree().create_timer(0.5).timeout
	if Boss:
		World.set_deferred("process_mode",Node.PROCESS_MODE_DISABLED)
		Boss.set_deferred("process_mode",Node.PROCESS_MODE_DISABLED)
	World.add_child(clone)
	get_tree().set_deferred("paused",true)
	
	


	
	
	
