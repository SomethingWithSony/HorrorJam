extends StaticBody3D
class_name Interactable

signal interacted(body)

@export var mesh : MeshInstance3D
@export var outline_material : Material

@export var prompt_key := "E"
@export var prompt_message := "Interact" + "\n [" + prompt_key + "]"


@export var interaction_distance : float = 6.0
var in_interactable_distance: bool = false
var hovering = false
var player_distance : float
var player : CharacterBody3D 

@onready var label := $"../CanvasLayer/Control/Label"
@onready var camera := get_viewport().get_camera_3d()


func _ready():
	player = get_tree().get_nodes_in_group("Player")[0]
	
func interact(body):
	if (in_interactable_distance):
		interacted.emit(body)
	
func _process(_delta):
	player_distance = global_position.distance_to(player.global_position)
	in_interactable_distance = player_distance <= interaction_distance
	
	if (in_interactable_distance and hovering):
		_update_label_position()
	
func _update_label_position():
	if camera and label:
		# Convert node's position to 2D screen coordinates
		var screen_pos = camera.unproject_position(global_position)
		# Offset upwards a bit
		screen_pos.y -= 40
		label.position = screen_pos

func highlight():
	if (in_interactable_distance):
		hovering = true
		_update_label_position()
		mesh.material_overlay = outline_material
		label.text = prompt_message
		label.show()
	

func remove_highlight():
	hovering = false
	label.hide()
	mesh.material_overlay = null
