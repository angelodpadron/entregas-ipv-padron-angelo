extends Sprite2D

var player
@export 
var projectile_scene: PackedScene
@onready
var fire_position:Marker2D = $FirePosition

var projectile_container: Node

func set_values(player:Sprite2D, projectile_container:Node):
	self.player = player
	self.projectile_container = projectile_container

func _on_timer_timeout():
	fire()
	
func fire():
	var projectile_instance:Projectile = projectile_scene.instantiate()
	projectile_container.add_child(projectile_instance)
	projectile_instance.set_starting_value(fire_position.global_position, (player.global_position - fire_position.global_position).normalized())
	projectile_instance.delete_requested.connect(on_projectile_delete_request)
	
func on_projectile_delete_request(projectile:Node):
	projectile_container.remove_child(projectile)
	projectile.queue_free()
