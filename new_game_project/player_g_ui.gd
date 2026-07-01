extends Control
@onready var Healthbar = $ProgressBar
@onready var abilitybar = $abilitybar
var player = false
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if self.get_parent():
		player = self.get_parent().get_parent().get_node("Player")
		

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if player:
		%HpText.text = var_to_str(player.Health)+  "/100"
		Healthbar.value = player.Health 
		
func reloadAbility():
	abilitybar.value = 0
	var timer = get_tree().create_timer(5,false)
	while timer.time_left != 0:
		if not is_inside_tree():return
		abilitybar.value = 100 * (1-timer.time_left/5)
		await get_tree().process_frame
	abilitybar.value = 100

		
