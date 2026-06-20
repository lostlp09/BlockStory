extends ProgressBar
@onready var Boss = $"../../../Boss"
@onready var label= $Label
func _process(delta: float) -> void:
    if Boss and  label:
        self.value = Boss.Health
        label.text = var_to_str(Boss.Health) + "/1000"
