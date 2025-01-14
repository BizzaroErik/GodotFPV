class_name State
extends Node

@export var move_speed: float = 400
@export var look_sense: float = 0.3

@export var gravity: int = ProjectSettings.get_setting("physics/2d/default_gravity")

var player: Player

func enter() -> void:
	pass

func exit() -> void:
	pass

func process_input(event: InputEvent) -> State:
	return null

func process_frame(delta: float) -> State:
	return null

func process_physics(delta: float) -> State:
	return null
