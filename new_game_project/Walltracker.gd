extends Node2D
@onready var Nearwallobject = $Nearwall
@export var isnearWall= false
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Nearwallobject.body_entered.connect(IsPlayernearwall.bind(true))
	Nearwallobject.body_exited.connect(IsPlayernearwall.bind(false))


# Called every frame. 'delta' is the elapsed time since the previous frame.
func IsPlayernearwall(body,boolean):
	if body.is_in_group("player"):
		isnearWall = boolean
		
