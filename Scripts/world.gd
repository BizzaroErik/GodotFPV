extends Node3D

@onready var color_rect: ColorRect = $UI/ColorRect
@onready var spawns: Node3D = $Spawns
@onready var navigation_region_3d: NavigationRegion3D = $Map/NavigationRegion3D
@onready var player: Player = $Player


var zombie: PackedScene = load("res://Scenes/zombie.tscn")
var instance: Zombie

func _ready() -> void:
	randomize()

func _on_player_player_hit() -> void:
	color_rect.visible = true
	await get_tree().create_timer(0.2).timeout
	color_rect.visible = false

func _get_random_child(parent_node):
	var random_id = randi() % parent_node.get_child_count()
	return parent_node.get_child(random_id)

func _on_zombie_spawn_timer_timeout() -> void:
	var spawn_point = _get_random_child(spawns).global_position
	instance = zombie.instantiate()
	instance.position = spawn_point
	instance.player = player
	navigation_region_3d.add_child(instance)
