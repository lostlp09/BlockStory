extends CharacterBody2D
var direction = 1
@onready var EnemyArea = $Area2D
@export var Health = 100
@export var MaxHP = 100
@export var Speed = 100
@export var time = 1
func ChangeDirection():
	await get_tree().create_timer(time).timeout
	direction *=-1
	ChangeDirection()


func _ready() -> void:
	EnemyArea.body_entered.connect(Enemyentered)
	%Healthbar.max_value = 50
	ChangeDirection()
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	self.velocity.y = 300 
	if Health != MaxHP:
		%Healthbar.visible = true
		%Healthbar.max_value = MaxHP
		%Healthbar.value = Health
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
	
	
	
