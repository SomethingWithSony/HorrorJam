extends Camera3D

@export var player: CharacterBody3D

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

func _process(delta):
	position = player.position + Vector3.UP * 10
