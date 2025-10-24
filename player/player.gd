extends CharacterBody3D


var direction : Vector2 = Vector2.ZERO
@export var movement_speed : float = 0.2
@export var camera : Camera3D

@export var infection : float
@export var infection_rate : float
@export var second_phase_infecntion : int = 30
@export var third_phase_infection : int = 70
@onready var infection_bar := $CanvasLayer/InfectionBar


var last_hovered_object : Interactable = null

# Updates
func _process(_delta):
	infection_bar.value = infection
	
func _physics_process(_delta):
	var mouse_position : Vector2 = get_viewport().get_mouse_position()
	
	movement_logic()
	move_and_slide()

	rotate_towards_mouse(mouse_position)
	interact_with_objects(mouse_position)
	

# Movement & Rotation Logic
func movement_logic():
	direction = Input.get_vector("left", "right", "up", "down").rotated(-rotation.y)
	velocity = Vector3(direction.x, 0, direction.y) * movement_speed
	position += velocity 
	
func rotate_towards_mouse(mouse_position: Vector2):
	var ray_result = cast_ray(mouse_position, 50)
	
	if(!ray_result.is_empty()):
		if (position.distance_to(ray_result.position) > 0.4 ):
			var target_position = ray_result.position
			target_position.y = global_transform.origin.y 
			look_at(target_position, Vector3.UP)
			
# Raycast
func cast_ray(mouse_position: Vector2 ,ray_length: int):
	var ray_origin = camera.project_ray_origin(mouse_position)
	var ray_direction = ray_origin + camera.project_ray_normal(mouse_position) * ray_length
	var ray_query = PhysicsRayQueryParameters3D.create(ray_origin,ray_direction)
	ray_query.collide_with_bodies = true
	var space_state = get_world_3d().direct_space_state
	return space_state.intersect_ray(ray_query) # ray result
	
# Interaction
func interact_with_objects(mouse_position: Vector2):
	var ray_result = cast_ray(mouse_position, 15)
	var current_hovered_object : Interactable = null
	
	if(!ray_result.is_empty()):		
		if (ray_result.collider is Interactable):	
			current_hovered_object = ray_result.collider
			current_hovered_object.highlight()
				
			if Input.is_action_just_pressed("interact"):
				current_hovered_object.interact(owner)
				
	if last_hovered_object and last_hovered_object != current_hovered_object:
		last_hovered_object.remove_highlight()
		
	last_hovered_object = current_hovered_object


# Infection
func _on_infection_timer_timeout():
	infection += infection_rate
	
func lower_infection_progress(value: float):
	infection -= value
	infection = clampf(infection, 0, 100)
