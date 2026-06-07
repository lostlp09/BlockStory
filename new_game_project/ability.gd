extends Node2D

@onready var World = $"../.."
@onready var player = $".."
const BeamEffect = preload("res://beameffekt.tscn")
var AllowToBeam = true
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	if Input.is_action_just_pressed("Beam"):
		if AllowToBeam:
			Beam()
			
	
func Beam() ->void:
	AllowToBeam = false
	var BeamObject = BeamEffect.instantiate()
	World.add_child(BeamObject)
	var direction = (get_global_mouse_position() - player.position).normalized()
	var Area = Area2D.new()
	var Collision = CollisionShape2D.new()
	var Shape = RectangleShape2D.new()
	Shape.size = Vector2(2000,100)	
	World.add_child(Area)
	Area.add_child(Collision)
	Collision.shape = Shape	
	var Position = player.position + (30 + Shape.size.x/2) * direction
	Area.position = Position
	BeamObject.position = Position
	Area.rotation = direction.angle()
	BeamObject.rotation = direction.angle()
	await  get_tree().physics_frame
	for EnemyArea in Area.get_overlapping_areas():
		if EnemyArea.get_parent().is_in_group("Enemy"):
			var Enemy = EnemyArea.get_parent()
			Enemy.GetDamageCall.bind(30).call()
	Area.queue_free()
	await get_tree().create_timer(1).timeout
	AllowToBeam = true
