class_name PlayerMovementState extends State

var player: Player
var animation: AnimationPlayer
var weapon: Weapons

# Called when the node enters the scene tree for the first time.
func _ready():
	await owner.ready
	player = owner as Player
	animation = player.ANIMATIONPLAYER

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass
