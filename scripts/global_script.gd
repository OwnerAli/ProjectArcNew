extends Node

var debug # Reference to DebubPanel node for property assignment
var chat # Reference to ChatPanel node for property assignment
var player # Reference to Player
var enemy

const SAVE_PATH: String = "res://savegame.bin" 

func save_game() -> void:
	var file = FileAccess.open(SAVE_PATH, FileAccess.WRITE)
	var data: Dictionary = {
		"position.x" : GlobalScript.player.position.x,
		"position.y" : GlobalScript.player.position.y,
		"position.z" : GlobalScript.player.position.z,
		"position.rotation" : GlobalScript.player._current_rotation
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
				player.position.x = int(current_line["position.x"])
				player.position.y = int(current_line["position.y"])
				player.position.z = int(current_line["position.z"])
				player._current_rotation = int(current_line["position.rotation"])
