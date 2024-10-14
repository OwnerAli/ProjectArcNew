class_name SprintingPlayerState extends PlayerMovementState

@export var speed: float = 10.0
@export var acceleration: float = 0.2
@export var deceleration : float = 0.25
@export var topAnimSpeed : float = 1.6

func enter(_previous_state) -> void:
	if animation.is_playing() and animation.current_animation == "JumpEnd":
		await animation.animation_finished
		animation.play("Sprinting",0.5,1.0)
	else:
		animation.play("Sprinting",0.5,1.0)

func exit() -> void:
	animation.speed_scale = 1.0

func update(delta):
	player.update_gravity(delta)
	player.update_input(speed, acceleration, deceleration)
	player.update_velocity()
	
	set_animation_speed(player.velocity.length())
	
	if Input.is_action_just_released("sprint") and player.velocity.length() > 0:
		transition.emit("WalkingPlayerState")
	
	if Input.is_action_just_pressed("crouch") and player.velocity.length() > 6:
		transition.emit("SlidingPlayerState")
	
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

func _input(event):
	if event.is_action_released("sprint"):
		if player.velocity.length() > 0:
			transition.emit("WalkingPlayerState")
		else:
			transition.emit("IdlePlayerState")
	
func set_animation_speed(spd) -> void:
	var alpha = remap(spd, 0.0, speed, 0.0, 1.0)
	animation.speed_scale = lerp(0.0, topAnimSpeed, alpha)
