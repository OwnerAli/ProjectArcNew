class_name CrouchingPlayerState extends PlayerMovementState

@export var speed: float = 2.0
@export var acceleration: float = 0.1
@export var deceleration: float = 0.25
@export_range(1, 6, 0.1) var crouchSpeed: float = 4.0

@onready var crouchShapeCast : ShapeCast3D = %CrouchShapeCast

var released: bool = false

func enter(previous_state) -> void:
	animation.speed_scale = 1.0
	if previous_state.name != "SlidingPlayerState":
		animation.play("Crouch", -1.0, crouchSpeed)
	else:
		animation.current_animation = "Crouch"
		animation.seek(1.0, true)
		
func exit() -> void:
	released = false
	
func update(delta):
	player.update_gravity(delta)
	player.update_input(speed, acceleration, deceleration)
	player.update_velocity()
	
	if Input.is_action_just_released("crouch"):
		uncrouch()
	elif !Input.is_action_pressed("crouch") and !released:
		released = true
		uncrouch()
	
	if Input.is_action_just_pressed("jump") and player.is_on_floor():
		transition.emit("JumpingPlayerState")
	
	if player.velocity.y < -3.0 and !player.is_on_floor():
		transition.emit("FallingPlayerState")
		
	if Input.is_action_just_pressed("attack"):
		animation.play("sword", -1, 5)
	
	if Input.is_action_just_released("attack"):
		animation.play("sword", -1, -5)
		
func uncrouch():
	if !crouchShapeCast.is_colliding():
		animation.play("Crouch", -1.0, -crouchSpeed, true)
		await animation.animation_finished
		if player.velocity.length() == 0:
			transition.emit("IdlePlayerState")
		else:
			transition.emit("WalkingPlayerState")
	elif crouchShapeCast.is_colliding():
		await get_tree().create_timer(0.1).timeout
		uncrouch()
