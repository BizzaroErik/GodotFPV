extends State

@export var idle_state: State
@export var running_state: State
@onready var head: Node3D = $"../../Head"
var speed = 5.0
const JUMP_VELOCITY = 6.5
var jump_direction: Vector3
var can_jump: bool = true

func enter() -> void:
	var input_dir := Input.get_vector("left", "right", "up", "down")
	# input_dir returns a Vector2  (left/right -1 to 1, up/down -1 to 1), we want to alway ignore
	# remove head.transform.basis to remove the look ability to change jump direction
	jump_direction = (head.transform.basis * Vector3(0, 0, input_dir.y)).normalized()

func exit() -> void:
	pass

func process_input(event: InputEvent) -> State:
	if event is InputEventMouseMotion:
		#Captures horizontal change across the x axis, applied to rotate along the head's y axis which moves left and right and y pointing up
		player.head.rotate_y(deg_to_rad(-event.relative.x * look_sense))
		#Captures vertical change across the y axis of the mouse, applied to the camera's x axis which extends forward and back and rotates up and down
		player.camera.rotate_x(deg_to_rad(-event.relative.y * look_sense))
		player.camera.rotation.x = clamp(player.camera.rotation.x, deg_to_rad(-80), deg_to_rad(80))
	return null

func process_frame(delta: float) -> State:
	return null

func process_physics(delta: float) -> State:
	# Add the gravity.
	if not player.is_on_floor():
		player.velocity += player.get_gravity() * delta
	
	player.velocity.x = lerp(player.velocity.x, jump_direction.x * speed, delta * 3.0)
	player.velocity.z = lerp(player.velocity.z, jump_direction.z * speed, delta * 3.0)

	player.move_and_slide()
	
	var distinct_square = 0.1
	if player.velocity.y == 0 and (player.velocity.x != 0 or player.velocity.x != 0) and player.is_on_floor():
		return running_state
	if player.velocity.length_squared() < distinct_square  and player.is_on_floor():
		return idle_state
	else:
		return null
