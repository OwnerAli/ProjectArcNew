extends PanelContainer

@onready var property_container = $MarginContainer/VBoxContainer

var property
var fps : String

func _ready():
	# Sets instance of debug in global to this (like JavaPlugin main class :D)
	GlobalScript.debug = self
	
	# Hide Debug Panel on load
	visible = false

func _process(delta):
	if !visible:
		return
	
	# Use delta time to get approx FPS and round to two decimal places !Disable VSync if fps is stuck at 60!
	fps = "%.2f" % (1.0/delta) # Gets FPS every frame (Engine.get_frames_per_second() gets FPS every sec
	
func _input(event):
	if event.is_action_pressed("debug"):
		visible = !visible

func add_property(title: String, value, order):
	var target
	target = property_container.find_child(title,true,false) # Try to find Label with same name
	
	# There is no label with same name
	if !target:
		target = Label.new()
		property_container.add_child(target) # Add new node as child to Vbox
		target.name = title # Set name to title
		target.text = target.name + ": " + str(value) # Set text of label
	elif visible: # If there IS a target and the Debug menu visible then rearrage the panel in order
		target.text = title + ": " + str(value)
		property_container.move_child(target,order) # Reorder property based on given order param
