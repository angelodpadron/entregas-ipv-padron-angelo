extends Sprite2D

@onready var cannon_tip = $CannonTip
@export var projectile_scene:PackedScene

var projectile_container:Node

func fire():
	var proj_instance = projectile_scene.instantiate()
	proj_instance.initialize(projectile_container, cannon_tip.global_position, global_position.direction_to(cannon_tip.global_position))
