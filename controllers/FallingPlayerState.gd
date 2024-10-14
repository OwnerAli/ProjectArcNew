class_name FallingPlayerState extends PlayerMovementState

@export var speed: float = 5.0
@export var acceleration: float = 0.1
@export var decelertion: float = 0.25
@export var doubleJumpVelocity: float = 4.5

var DOUBLE_JUMP: bool = false

func enter(_previous_state) -> void:
	animation.pause()
	
func exit() -> void:
	DOUBLE_JUMP = false

func update(delta: float) -> void:
	player.update_gravity(delta)
	player.update_input(speed,acceleration,decelertion)
	player.update_velocity()
	
	if Input.is_action_just_pressed("jump") and !DOUBLE_JUMP:
		DOUBLE_JUMP = true
		player.velocity.y = doubleJumpVelocity
		
	if player.is_on_floor():
		animation.play("JumpEnd")
		transition.emit("IdlePlayerState")
		
	if Input.is_action_just_pressed("attack"):
		animation.play("sword", -1, 5)
	
	if Input.is_action_just_released("attack"):
		animation.play("sword", -1, -5)
