extends CharacterBody2D
@export var GetDamageCall:Callable

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	GetDamageCall = GetDamage 
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
func GetDamage(Amount):
	self.set_meta("Health",self.get_meta("Health")- Amount)
	print(self.get_meta("Health"))
	pass
	
