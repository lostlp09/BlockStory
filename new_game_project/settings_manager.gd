extends Node2D
@onready var World =  self.get_parent().get_parent()
var SettingsMenue = preload("res://Settings.tscn")
var Clone = false
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
		if Input.is_action_just_pressed("Settingsopen") :
			if Clone:
				print("test")
				Clone.queue_free()
				get_tree().paused = false
				SaveStats.SaveData()
			else:
				Clone = SettingsMenue.instantiate()
				World.add_child(Clone)
				get_tree().paused = true
				
	
