extends CharacterBody3D

var direction : Vector2 = Vector2.ZERO
@export var movement_speed : float = 0.2
@export var camera : Camera3D
	

func movement_logic():
	direction = Input.get_vector("left", "right", "up", "down").rotated(-rotation.y)
	velocity = Vector3(direction.x, 0, direction.y) * movement_speed
	position += velocity 
	

func cast_ray(mouse_position: Vector2 ,ray_length: int):
	var ray_origin = camera.project_ray_origin(mouse_position)
	var ray_direction = ray_origin + camera.project_ray_normal(mouse_position) * ray_length
	var ray_query = PhysicsRayQueryParameters3D.create(ray_origin,ray_direction)
	ray_query.collide_with_bodies = true
	var space_state = get_world_3d().direct_space_state
	return space_state.intersect_ray(ray_query) # ray result
	
func rotate_towards_mouse(mouse_position: Vector2):
	var ray_result = cast_ray(mouse_position, 50)
	
	if(!ray_result.is_empty()):
		if (position.distance_to(ray_result.position) > 0.4 ):
			var target_position = ray_result.position
			target_position.y = global_transform.origin.y 
			look_at(target_position, Vector3.UP)
			
			
func interact_with_objects(mouse_position: Vector2):
	var ray_result = cast_ray(mouse_position, 15)
	
	if(!ray_result.is_empty()):		
		if (ray_result.collider is Interactable):		
			if Input.is_action_just_pressed("interact"):
				ray_result.collider.interact(owner)

			
func _physics_process(_delta):
	var mouse_position : Vector2 = get_viewport().get_mouse_position()
	
	movement_logic()
	move_and_slide()

	rotate_towards_mouse(mouse_position)
	interact_with_objects(mouse_position)
