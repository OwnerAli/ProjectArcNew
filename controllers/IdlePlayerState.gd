class_name IdlePlayerState extends PlayerMovementState

@export var acceleration: float = 0.2
@export var deceleration : float = 0.25

func enter(_previous_state) -> void:
	if animation.is_playing() and animation.current_animation == "JumpEnd":
		await animation.animation_finished
		animation.pause()
	else:
		animation.pause()

func update(delta):
	player.update_gravity(delta)
	player.update_input(7.0, acceleration, deceleration)
	player.update_velocity()
	
	if Input.is_action_just_pressed("crouch"):
		transition.emit("CrouchingPlayerState")
	
	if player.velocity.length() > 0.0 and player.is_on_floor():
		transition.emit("WalkingPlayerState")
	
	if Input.is_action_just_pressed("jump") and player.is_on_floor():
		transition.emit("JumpingPlayerState")
		
	if player.velocity.y < -3.0 and !player.is_on_floor():
		transition.emit("FallingPlayerState")
		
	if Input.is_action_just_pressed("attack"):
		player.swordHitbox.monitoring = true
		animation.play("sword", -1, 5)
	
	if Input.is_action_just_released("attack"):
		player.swordHitbox.monitoring = false
		animation.play("sword", -1, -5)
	
