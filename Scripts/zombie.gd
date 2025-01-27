class_name Zombie
extends CharacterBody3D


const SPEED = 5.0
const JUMP_VELOCITY = 4.5
const ATTACK_RANGE = 2.0

var player = null
var state_machine

@onready var nav_agent: NavigationAgent3D = $NavigationAgent3D
@onready var anim_tree = $AnimationTree


func _ready() -> void:
	state_machine = anim_tree.get("parameters/playback")
	

func _process(delta: float) -> void:
	velocity = Vector3.ZERO
	
	match state_machine.get_current_node():
		"Run":
			nav_agent.set_target_position(player.global_transform.origin)
			var next_nav_point = nav_agent.get_next_path_position()
			velocity = (next_nav_point - global_transform.origin).normalized() * SPEED
			rotation.y = lerp_angle(rotation.y, atan2(-velocity.x, -velocity.z), delta * 5.0)
		"Attack":
			look_at(Vector3(player.global_position.x, global_position.y, player.global_position.z), Vector3.UP)
	
	
	#Attack Condition
	anim_tree.set("parameters/conditions/attack", _target_in_range())
	anim_tree.set("parameters/conditions/run", !_target_in_range())
	
	move_and_slide()

func _target_in_range():
	return global_position.distance_to(player.global_position) <= ATTACK_RANGE

func _hit_finished():
	if global_position.distance_to(player.global_position) < ATTACK_RANGE + 1:
		var dir = global_position.direction_to(player.global_position)
		player.hit(dir)
	
