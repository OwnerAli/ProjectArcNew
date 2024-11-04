extends Node

const SAVE_PATH: String = "res://savegame.bin" 

func save_game() -> void:
	var file = FileAccess.open(SAVE_PATH, FileAccess.WRITE)
	var data: Dictionary = {
		"position.x" : GlobalScript.player.position.x,
		"position.y" : GlobalScript.player.position.y,
		"position.z" : GlobalScript.player.position.z,
	}
	var jstr = JSON.stringify(data)
	file.store_line(jstr)
	
func load_game() -> void:
	var file = FileAccess.open(SAVE_PATH, FileAccess.READ)
	if !file: return
	if file == null: return
	if FileAccess.file_exists(SAVE_PATH) == true:
		if !file.eof_reached():
			var current_line = JSON.parse_string(file.get_line())
			if current_line:
				GlobalScript.position.x = int(current_line["position.x"])
				GlobalScript.position.y = int(current_line["position.y"])
				GlobalScript.position.z = int(current_line["position.z"])
