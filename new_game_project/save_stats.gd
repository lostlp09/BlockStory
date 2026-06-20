extends Node
var PlayerData = {"Checkpoint":0}
func _ready() -> void:
	PlayerData = LoadData()
	print(PlayerData)
	
	
	
func  DeleteData():
	PlayerData = {"Checkpoint":0}
	SaveData()
	


func  LoadData():
	if not FileAccess.file_exists("user://saveBlockStory"):
		return PlayerData
	var Data = FileAccess.open("user://saveBlockStory",FileAccess.READ)
	var FullData = Data.get_var()
	return FullData
	
func SaveData():
	var savedata = FileAccess.open("user://saveBlockStory",FileAccess.WRITE)
	savedata.store_var(PlayerData)
