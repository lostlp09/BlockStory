extends ProgressBar
@onready var Boss = $"../../../Boss"
@onready var label= $Label
func _process(delta: float) -> void:
	self.value = Boss.Health
	label.text = var_to_str(Boss.Health) + "/1000"

	pass
