class_name Player
extends CharacterBody3D

const LOOK_SENSE = 0.3
@onready var head: Node3D = $Head
@onready var camera: Camera3D = $Head/Camera3D

const BASE_FOV = 70.0
const FOV_CHANGE = 1.3

@onready var state_machine: Node = $state_machine

func _ready():
	#Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	camera.fov = BASE_FOV
	state_machine.init(self)

func _unhandled_input(event):
	state_machine.process_input(event)

func _physics_process(delta: float) -> void:
	state_machine.process_physics(delta)

func _process(delta: float) -> void:
	state_machine.process_frame(delta)
