extends Node2D
@onready var playergui =$"../../CanvasLayer/PlayerGUi"
@onready var World = $"../.."
@onready var player = $".."
@onready var BeamSoundEffect = preload("res://beam_sound_effect.tscn")
const BeamEffect = preload("res://beameffekt.tscn")
var AllowToBeam = true
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	if Input.is_action_just_pressed("Beam"):
		if AllowToBeam:
			playergui.reloadAbility()
			var  clone = BeamSoundEffect.instantiate()
			World.add_child(clone)
			clone.position = player.position
			Beam()
			
	
func Beam() ->void:
	AllowToBeam = false
	get_tree().create_timer(5).timeout.connect(func (): AllowToBeam = true)
	var BeamObject = BeamEffect.instantiate()
	World.add_child(BeamObject)
	var direction = (get_global_mouse_position() - player.position).normalized()
	var Area = Area2D.new()
	Area.collision_layer = 0
	Area.collision_mask = 0
	Area.set_collision_layer_value(1,true)
	Area.set_collision_layer_value(4,true)
	Area.set_collision_mask_value(1,true)
	Area.set_collision_mask_value(4,true)
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
		if EnemyArea.is_in_group("NoHitBox"):continue
		if EnemyArea.get_parent().is_in_group("Enemy"):
			var Enemy = EnemyArea.get_parent()
			Enemy.GetDamage(30)
	Area.queue_free()
	
