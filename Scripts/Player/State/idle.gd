extends State

@export var running_state: State
@export var jumping_state: State

const WALK_SPEED = 5.0
const SPRINT_SPEED = 10.0
var speed = 5.0
const JUMP_VELOCITY = 6.5

func enter() -> void:
	pass

func exit() -> void:
	pass

func process_input(event: InputEvent) -> State:
	if event is InputEventMouseMotion:
		#Captures horizontal change across the x axis, applied to rotate along the head's y axis which moves left and right and y pointing up
		player.head.rotate_y(deg_to_rad(-event.relative.x * look_sense))
		#Captures vertical change across the y axis of the mouse, applied to the camera's x axis which extends forward and back and rotates up and down
		player.camera.rotate_x(deg_to_rad(-event.relative.y * look_sense))
		player.camera.rotation.x = clamp(player.camera.rotation.x, deg_to_rad(-80), deg_to_rad(80))
	
	if Input.is_action_just_pressed("jump") and player.is_on_floor():
		return jumping_state
	var input_dir := Input.get_vector("left", "right", "up", "down")
	if input_dir != Vector2(0,0):
		return running_state
	return null

func process_frame(delta: float) -> State:
	return null

func process_physics(delta: float) -> State:
	# Add the gravity.
	if not player.is_on_floor():
		player.velocity += player.get_gravity() * delta
	return null
	
