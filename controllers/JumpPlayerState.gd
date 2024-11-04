class_name JumpingPlayerState extends PlayerMovementState

@export var speed: float = 6.0
@export var acceleration: float = 0.1
@export var deceleration: float = 0.25
@export var jumpVelocity: float = 11
@export var doubleJumpVelocity: float = 9.5
@export var doubleJumpCooldown: float = 2.5
@export_range(0.5,1.0,0.01) var inputMultiplier: float = 0.85

var _previous_state
var _double_jump : bool = false

func enter(previous_state) -> void:
	player.velocity.y += jumpVelocity
	animation.play("JumpStart")
	_previous_state = previous_state

func update(delta):
	player.update_gravity(delta)
	player.update_input(player._current_speed, acceleration, deceleration)
	player.update_velocity()
	
	if Input.is_action_just_released("jump"):
		if player.velocity.y > 0:
			player.velocity.y = player.velocity.y / 2.0
	
	if player.is_on_floor():
		animation.play("JumpEnd")
		if _previous_state.name == "SprintingPlayerState":
			transition.emit("SprintingPlayerState")
		else:
			transition.emit("IdlePlayerState")
	elif Input.is_action_just_pressed("jump"):
		if _double_jump:
			GlobalScript.chat.add_message("doubleJumpCooldownMessage", "DoubleJump is still on cooldown!", true)
			return;
		double_jump()
		
	if Input.is_action_just_pressed("attack"):
		animation.play("sword", -1, 5)
	
	if Input.is_action_just_released("attack"):
		animation.play("sword", -1, -3, true)

func double_jump():
	_double_jump = true
	player.velocity.y = doubleJumpVelocity
	await get_tree().create_timer(doubleJumpCooldown).timeout
	_double_jump = false
