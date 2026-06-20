extends CharacterBody2D
var Shockwave = preload("res://ShockWave.tscn")
@export var Target = false
@onready var  KnockBackArea = $KnockBackARea
@export var Health = 1000
var player = null
var Bullet = preload("res://Bullet.tscn")
var UsingAbility = false
var Spike = preload("res://SpikeAttack.tscn")
@onready var World = $".."
signal Abilityended
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	randomattack()
	KnockBackArea.body_entered.connect(InArea)
	Abilityended.connect(randomattack)
	
	if self.get_parent().get_node("Player"):
		player = self.get_parent().get_node("Player")
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	if not UsingAbility and player:
		var distance = abs(player.position.x-self.position.x)
		if distance > 300:
			self.velocity = Vector2(player.position.x-self.position.x,0).normalized() * 16000 * delta
			move_and_slide()
func  JumpToPlayer(GoalPosition:Vector2,OldPosition:Vector2,OldHight):
		
		while self.position.x != GoalPosition.x:
			var ding  =move_toward(self.position.x,GoalPosition.x,800 * get_physics_process_delta_time())
			var hight = Parabelfunc(OldPosition.x,GoalPosition.x,ding,OldHight)
			self.position =Vector2(ding,hight)
			await  get_tree().physics_frame
		CreateShockwave()
		await  get_tree().create_timer(0.5).timeout
		Abilityended.emit()
		
		

func Parabelfunc(Pos1,Pos2,currentvalue,OldHight):
	return   (currentvalue -Pos1 )*(currentvalue-Pos2) * 0.003 +OldHight
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
		var timer = get_tree().create_timer(0.5)
		while  timer.time_left > 0:
			var x = 2- timer.time_left * 4
			self.position.y = hight - (-1* pow(x-1,2)+1 )* 200
			await  get_tree().physics_frame
		self.position.y = hight
		CreateShockwave()
		
	Abilityended.emit()
func CreateShockwave():
	var Shockwave = Shockwave.instantiate()
	self.get_parent().add_child(Shockwave)
	Shockwave.position = self.position + Vector2(0,22)
func BulletAbility():
	var InstanceBullet = Bullet.instantiate()
	self.get_parent()
	if player:
		InstanceBullet.position = self.position
		self.get_parent().add_child.call_deferred(InstanceBullet)
		var direction  = Vector2((player.position.x - self.position.x),0).normalized()
		InstanceBullet.launch(direction)
	await  get_tree().create_timer(1).timeout
	Abilityended.emit()
func GetDamage(Amount):
	Health -= Amount

func  randomattack():
	UsingAbility = false
	randi_range(0,3)
	await get_tree().create_timer(3).timeout
	UsingAbility = true
	while  true:
		var randomnumber = randi_range(0,3)
		if randomnumber ==0:
			print("yod")
			if World.isnearWall:
				print("SpikeAttack")
				SpikeAttack()
				break
			if abs(player.position.x - self.position.x) > 300 :
				JumpToPlayer(player.position,self.position,self.position.y)
				break
		elif randomnumber ==1:
			BulletAbility()
			break
		elif randomnumber == 2:
			AngryJumps()
			break
		
		
func  SpikeAttack():
	var SpikeClone = Spike.instantiate()
	World.add_child(SpikeClone)
	SpikeClone.position = Vector2(player.position.x,365)
	SpikeClone.launch(365)
	await get_tree().create_timer(1).timeout
	Abilityended.emit()
	
		
		
		
