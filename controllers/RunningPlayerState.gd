class_name RunningPlayerState

extends State

func update(delta):
	if GlobalScript.player.velocity.length() > 6.0:
		transition.emit("IdlePlayerState")
