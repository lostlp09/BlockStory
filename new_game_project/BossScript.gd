extends CharacterBody2D
var Shockwave = preload("res://ShockWave.tscn")
@export var Target = false
@onready var  KnockBackArea = $KnockBackARea
@export var Health = 1000
var player = null
var Bullet = preload("res://Bullet.tscn")
var UsingAbility = false
var Spike = preload("res://SpikeAttack.tscn")
var timerForArea = 0
@onready var timer = get_tree().create_timer(3,false)
@export var IsPaused = false
@onready var World = $".."
@onready var ImpactSound = preload("res://impactSoundEffect.tscn")
signal Abilityended
var PlayerInArea = false
var TimerInstance = null	
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	KnockBackArea.body_entered.connect(InArea)
	Abilityended.connect(func():
		timer = get_tree().create_timer(3,false)
		UsingAbility = false
		)
	if self.get_parent().get_node("Player"):
		player = self.get_parent().get_node("Player")
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	if KnockBackArea.has_overlapping_bodies():
		timerForArea += delta
		if timerForArea >= 0.5:
			var Body =KnockBackArea.get_overlapping_bodies()[0]
			var direction:Vector2 =  (Body.position - self.position).normalized()
			direction = Vector2(direction.x,0).normalized()
			Body.playerKnockBackStun(direction,1000)
			timerForArea = 0
	if player:
		print(abs(player.position.x - self.position.x))
	if timer:
		if timer.time_left == 0:
			timer  = false
			randomattack()
	if not UsingAbility and player:
		var distance = abs(player.position.x-self.position.x)
		if distance > 110:
			self.velocity = Vector2(player.position.x-self.position.x,0).normalized() * 10000 * delta
			move_and_slide()
func  JumpToPlayer(GoalPosition:Vector2,OldPosition:Vector2,OldHight):
	
		while self.position.x != GoalPosition.x :
			if not is_inside_tree():return
			if not get_tree().paused:
				print("jump")
				var ding  =move_toward(self.position.x,GoalPosition.x,800 * get_physics_process_delta_time())
				var hight = Parabelfunc(OldPosition.x,GoalPosition.x,ding,OldHight)
				self.position =Vector2(ding,hight)
			await  get_tree().physics_frame
		CreateShockwave()
		await  get_tree().create_timer(0.5,false).timeout
		Abilityended.emit()
		
		

func Parabelfunc(Pos1,Pos2,currentvalue,OldHight):
	return   (currentvalue -Pos1 )*(currentvalue-Pos2) * 0.005 +OldHight
func InArea(Body):
	if Body.is_in_group("player"):
		var direction:Vector2 =  (Body.position - self.position).normalized()
		if direction.y>= 0.9:
			direction = Vector2(direction.x,0).normalized()
		Body.playerKnockBackStun(direction,1000)
		Body.GetDamage(10)

func AngryJumps():
	var hight = self.position.y
	for i in range(3):
		var timer = get_tree().create_timer(0.5,false)

		while  timer.time_left > 0:
			if not is_inside_tree():return
			var x = 2- timer.time_left * 4
			self.position.y = hight - (-1* pow(x-1,2)+1 )* 200
			await  get_tree().physics_frame
		self.position.y = hight
		CreateShockwave()
		
	Abilityended.emit()
func CreateShockwave():
	var Impact = ImpactSound.instantiate()
	World.call_deferred("add_child",Impact)
	Impact.position = self.position
	var Shockwave = Shockwave.instantiate()
	self.get_parent().add_child(Shockwave)
	Shockwave.position = self.position + Vector2(0,22)
func BulletAbility():
	var InstanceBullet = Bullet.instantiate()
	self.get_parent()
	if player:
		InstanceBullet.position = self.position + Vector2(0,35)
		self.get_parent().add_child.call_deferred(InstanceBullet)
		var direction  = Vector2((player.position.x - self.position.x),0).normalized()
		InstanceBullet.launch(direction)
	await  get_tree().create_timer(1,false).timeout
	Abilityended.emit()
func GetDamage(Amount):
	Health -= Amount
	if Health <=0:
		get_tree().call_deferred("change_scene_to_file","res://Win.tscn")
func  randomattack():
	UsingAbility = true
	while  true:
		var distance =  abs(player.position.x - self.position.x)
		var randomnumber = randi_range(0,3)
		if randomnumber ==0:
			print("yod")
			if World.isnearWall:
				print("SpikeAttack")
				SpikeAttack()
				break
			elif distance > 200 :
				JumpToPlayer(player.position,self.position,self.position.y)
				break
			else:
				SpikeAttack()
				break
		elif randomnumber ==1:
			if distance >= 300:
				BulletAbility()
				break
			else:
				await get_tree().process_frame
		elif randomnumber == 2:
			AngryJumps()
			break
		
		
func  SpikeAttack():
	var SpikeClone = Spike.instantiate()
	World.add_child(SpikeClone)
	SpikeClone.position = Vector2(player.position.x,735)
	SpikeClone.launch(735)
	await get_tree().create_timer(2,false).timeout
	Abilityended.emit()
	
		
		
		
