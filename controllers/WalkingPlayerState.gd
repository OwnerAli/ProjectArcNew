class_name WalkingPlayerState extends PlayerMovementState

@export var speed: float = 7.0
@export var acceleration: float = 0.2
@export var deceleration : float = 0.25
@export var topAnimSpeed : float = 2.0

func enter(_previous_state) -> void:
	if animation.is_playing() and animation.current_animation == "JumpEnd":
		await animation.animation_finished
		animation.play("Walking",-1.0,1.0)
	else:
		animation.play("Walking",-1.0,1.0)

func exit() -> void:
	animation.speed_scale = 1.0

func update(delta):
	player.update_gravity(delta)
	player.update_input(speed, acceleration, deceleration)
	player.update_velocity()
	
	set_animation_speed(player.velocity.length())
	
	if Input.is_action_just_pressed("crouch"):
		transition.emit("CrouchingPlayerState")
	
	if player.velocity.length() == 0.0:
		transition.emit("IdlePlayerState")
			
	if Input.is_action_just_pressed("jump") and player.is_on_floor():
		transition.emit("JumpingPlayerState")
	
	if player.velocity.y < -3.0 and !player.is_on_floor():
		transition.emit("FallingPlayerState")
	
	if Input.is_action_just_pressed("attack"):
		animation.play("sword", -1, 5)
	
	if Input.is_action_just_released("attack"):
		animation.play("sword", -1, -5)

func _input(event):
	if event.is_action_pressed("sprint"):
		transition.emit("SprintingPlayerState")
		
func set_animation_speed(spd) -> void:
	var alpha = remap(spd, 0.0, speed, 0.0, 1.0)
	animation.speed_scale = lerp(0.0, topAnimSpeed, alpha)
