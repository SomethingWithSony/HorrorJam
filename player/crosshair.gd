extends TextureRect

func _process(_delta):
	var mouse_pos = get_viewport().get_mouse_position()
	position = mouse_pos - (size / 2) # offset
