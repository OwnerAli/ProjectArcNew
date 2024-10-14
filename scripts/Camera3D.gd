extends Camera3D

@export var mainCam : Node3D

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	global_transform = mainCam.global_transform
