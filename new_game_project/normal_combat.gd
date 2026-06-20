extends Node2D
var allowedToAttack = true
var Attack = preload("res://attack1.tscn")
var AttackHitbox = preload("res://M1Damage.tscn")
@onready var World = $"../.."
@onready var player = $".."
var CanAttack  = true

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func _physics_process(delta: float) -> void:
	if Input.is_action_just_pressed("Attack") and CanAttack:
		CanAttack = false
		var direction = (get_global_mouse_position() - player.position).normalized()
		var object = Attack.instantiate()
		World.add_child(object)
		object.position = player.position + direction * 40
		object.rotation = direction.angle() + (PI/8)
		var Hitbox = AttackHitbox.instantiate()
		World.add_child(Hitbox)
		Hitbox.position = player.position + 60 * direction
		Hitbox.rotation = direction.angle()
		var Area:Area2D = Hitbox.get_node("Area2D")
		await  get_tree().physics_frame
		var GiveKnockback = true
		for AreaObject in Area.get_overlapping_areas():
			if AreaObject.get_parent().is_in_group("Enemy") and GiveKnockback and not AreaObject.is_in_group("NoHitBox"):
				print("test")
				var NewDirection = (AreaObject.get_parent().position - player.position).normalized() * -1
				player.playerKnockBack(NewDirection ,600)
				GiveKnockback = false
			var Enemy = AreaObject.get_parent()
			if Enemy.is_in_group("Enemy"):
				Enemy.GetDamage(10)	
		Hitbox.queue_free()
		get_tree().create_timer(0.2).timeout.connect(func (): CanAttack  = true)
