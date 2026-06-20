extends CharacterBody2D
var direction = 1
@onready var EnemyArea = $Area2D
@onready var NearbyArea = $NearbyArea
@export var Health = 100
var CanAttack = true
var PlayerIsIn = false
@export var Speed = 100
@export var time = 1
var EnemyBullet = preload("res://Enemybullet.tscn")
func ChangeDirection():
	await get_tree().create_timer(time).timeout
	direction *=-1
	ChangeDirection()


func _ready() -> void:
	EnemyArea.body_entered.connect(Enemyentered)
	NearbyArea.body_entered.connect(PlayerNearBy)
	NearbyArea.body_exited.connect(PlayerExit)
	ChangeDirection()
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	if PlayerIsIn and CanAttack :
		print("Attacke")
		CanAttack = false
		get_tree().create_timer(2).timeout.connect(func ():CanAttack = true)
		var bullet=  EnemyBullet.instantiate()
		self.get_parent().add_child(bullet)
		bullet.position = self.position
		
	self.velocity.x = move_toward(self.velocity.x,Speed * direction,10)
	
	move_and_slide()
func GetDamage(Amount ):
	Health -= Amount
	if Health <= 0:
		self.queue_free()

func Enemyentered(Body):
	print(Body)
	if Body.is_in_group("player"):
		var direction = (Body.position - self.position).normalized()
		Body.playerKnockBackStun(direction,800)
		Body.GetDamage(10)
		print(Body.Health)
		print(direction)
func PlayerNearBy(Body):
	if Body.is_in_group("player"):
		PlayerIsIn = true
		print("yo")
func  PlayerExit(Body):
	if Body.is_in_group("player"):
		PlayerIsIn = false

	
	
	
