extends Node2D
var allowedToAttack = true
var Attack = preload("res://attack1.tscn")
@onready var World = $"../.."
@onready var player = $".."
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


func _physics_process(delta: float) -> void:
	if Input.is_action_just_pressed("Attack"):
		print("spawn")
		var direction = (get_global_mouse_position() - player.position).normalized()
		var object = Attack.instantiate()
		World.add_child(object)
		object.position = player.position + direction * 40
		object.rotation = direction.angle() + (PI/8)
		
		
		
