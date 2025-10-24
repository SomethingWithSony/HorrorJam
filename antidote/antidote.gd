extends "res://interaction/interactable.gd"

@export var antidote_efficiency : float = 10

func _on_interacted(_body):
	player.lower_infection_progress(antidote_efficiency)
	remove_highlight()
	queue_free()
