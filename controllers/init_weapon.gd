class_name TheWeapon extends Node3D

@export var weaponType: Weapons

@onready var weapon_mesh: MeshInstance3D = %MeshInstance3D

# Called when the node enters the scene tree for the first time.
func _ready():
	load_weapon()

func load_weapon():
	weapon_mesh.mesh = weaponType.mesh
	position = weaponType.position
	rotation_degrees = weaponType.rotation
	
func _attack():
	var camera = GlobalScript.player.CAMERA_CONTROLLER
	var space_state = camera.get_world_3d().direct_space_state
	var screen_center = get_viewport().size / 2
	print(screen_center)
