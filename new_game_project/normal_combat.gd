extends Node2D
var allowedToAttack = true
@onready var player = $".."
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


func physics_process(delta: float) -> void:
	if Input.is_action_just_pressed("Attack") and allowedToAttack:
		var direction = (get_global_mouse_position() - player.position).normalized()
		
		
