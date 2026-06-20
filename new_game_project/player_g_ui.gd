extends Control
@onready var Healthbar = $ProgressBar
var player = false
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if self.get_parent():
		player = self.get_parent().get_parent().get_node("Player")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if player:
		Healthbar.value = player.Health 
		
