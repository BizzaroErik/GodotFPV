extends State

@export var idle_state: State
@export var jumping_state: State

const WALK_SPEED = 5.0
const SPRINT_SPEED = 10.0
var speed = 5.0
const JUMP_VELOCITY = 6.5

@onready var head: Node3D = $"../../Head"
@export var head_bob: bool = false
const BOB_FREQ = 2.0
const BOB_AMP = 0.08
var t_bob = 0.0


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
	return null

func process_frame(delta: float) -> State:
	return null

func process_physics(delta: float) -> State:
	# Add the gravity.
	if not player.is_on_floor():
		player.velocity += player.get_gravity() * delta
	# Handle jump.
	if Input.is_action_just_pressed("jump") and player.is_on_floor():
		player.velocity.y = JUMP_VELOCITY
	if Input.is_action_pressed("sprint"):
		speed = SPRINT_SPEED
	else:
		speed = WALK_SPEED
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir := Input.get_vector("left", "right", "up", "down")
	#Go to where head is facing not body
	var direction := (head.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	
	if player.is_on_floor():
		if direction:
			player.velocity.x = direction.x * speed
			player.velocity.z = direction.z * speed
		else:
			player.velocity.x = lerp(player.velocity.x, direction.x * speed, delta * 1.0)
			player.velocity.z = lerp(player.velocity.z, direction.z * speed, delta * 1.0)
	else:
		player.velocity.x = lerp(player.velocity.x, direction.x * speed, delta * 3.0)
		player.velocity.z = lerp(player.velocity.z, direction.z * speed, delta * 3.0)
	t_bob += delta * player.velocity.length() * float(player.is_on_floor())
	player.camera.transform.origin = _headbob(t_bob)

	var velocity_clamped = clamp(player.velocity.length(), 0.5, SPRINT_SPEED)
	var target_fov = player.BASE_FOV + player.FOV_CHANGE + velocity_clamped
	player.camera.fov = lerp(player.camera.fov, target_fov, delta * 14.0)
	player.move_and_slide()
	
	var distinct_square = 0.05
	if player.velocity.y != 0:
		return jumping_state
	if player.velocity.length_squared() < distinct_square:
		return idle_state
	else:
		return null
	#for i in player.get_slide_collision_count():
		#var collision = player.get_slide_collision(i)
		#if collision.get_collider().name == 'brick-wall' and !player.is_on_floor():
			#player.state = 'wall_running'

func _headbob(time) -> Vector3:
	var pos = Vector3.ZERO
	pos.y = sin(time * BOB_FREQ) * BOB_AMP
	pos.x = cos(time * BOB_FREQ /2) * BOB_AMP
	return pos
