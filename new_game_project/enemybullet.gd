extends Node2D

@export var target = null
@onready var  Area = $Area2D
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	get_tree().create_timer(3).timeout.connect(func():self.queue_free())
	print(self.get_parent())
	target = self.get_parent().get_node("Player")
	Area.body_entered.connect(func (body): if body.is_in_group("player"):
		var direction = ( body.position-self.position).normalized()
		body.playerKnockBack(direction,300)
		body.GetDamage(10)
		self.queue_free()
		)
		

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	if target:
		self.position += (target.position - self.position).normalized() * 200 *delta

func GetDamage(Amount):
	self.queue_free()
	
