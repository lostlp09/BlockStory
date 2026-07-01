extends Control

@onready var Boss = %Boss
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var tween = self.create_tween() 
	tween.tween_property($Sprite2D,"modulate",Color(1.0, 1.0, 1.0),0.4)
	await get_tree().create_timer(2,false).timeout
	tween = self.create_tween()
	tween.tween_property($Sprite2D,"modulate",Color(1.0, 1.0,1,0),0.4)
	await get_tree().create_timer(1,false).timeout
	%Boss.set_deferred("process_mode",Node.ProcessMode.PROCESS_MODE_INHERIT)
	self.queue_free()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
