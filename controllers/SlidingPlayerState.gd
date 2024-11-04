class_name SlidingPlayerState extends PlayerMovementState

@export var speed: float = 10.0
@export var acceleration: float = 0.1
@export var deceleration: float = 0.25
@export var tiltAmount: float = 0.09
@export_range(1, 6, 0.1) var slideAnimSpeed: float = 8.0

@onready var crouchShapeCase: ShapeCast3D = %CrouchShapeCast

@warning_ignore("unused_parameter")
func enter(previous_state) -> void:
	set_tilt(player._current_rotation)
	animation.get_animation("Sliding").track_set_key_value(5,0,player.velocity.length())
	animation.speed_scale = 1.0
	animation.play("Sliding", -1.0, slideAnimSpeed)
	
func update(delta):
	player.update_gravity(delta)
	player.update_velocity()
	
	if Input.is_action_just_pressed("jump") and player.is_on_floor():
		transition.emit("JumpingPlayerState")
		
	if Input.is_action_just_pressed("attack"):
		animation.play("sword", -1, 5)
	
	if Input.is_action_just_released("attack"):
		animation.play("sword", -1, -3, true)

func set_tilt(player_rotation) -> void:
	var tilt = Vector3.ZERO
	tilt.z = clamp(tiltAmount * player_rotation, -0.1, 0.1)
	if tilt.z == 0.0:
		tilt.z = 0.05
	animation.get_animation("Sliding").track_set_key_value(3,1,tilt)
	animation.get_animation("Sliding").track_set_key_value(3,2,tilt)

func finish():
	animation.play("Crouch", -1.0, -3.5, true)
	transition.emit("SprintingPlayerState")
