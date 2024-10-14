extends PanelContainer

@onready var property_container = %ChatContainer

func _ready():
	# Sets instance of chat in global to this (like JavaPlugin main class :D)
	GlobalScript.chat = self
	
	# Hide Chat Panel on load
	visible = false

func add_message(title: String, message: String, _error: bool):
	var target
	target = property_container.find_child(title,true,false)
	
	if !target:
		target = Label.new()
		target.text = message
		property_container.add_child(target)
		visible = true
		await get_tree().create_timer(1).timeout
		property_container.remove_child(target)
		if property_container.get_child_count(true) < 1:
			visible = false
