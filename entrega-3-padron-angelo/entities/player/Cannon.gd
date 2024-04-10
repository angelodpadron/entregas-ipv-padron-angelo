extends Sprite2D

@onready var fire_position:Marker2D = $FirePosition	 # Tambien se puede utilizar := para inferir el tipo a partir del nodo
@export var projectile_scene:PackedScene

var projectile_container:Node

func fire():
	var projectile_instance:Projectile = projectile_scene.instantiate()
	projectile_container.add_child(projectile_instance)
	projectile_instance.set_starting_value(fire_position.global_position, (fire_position.global_position - global_position).normalized())
	# projectile_instance.connect("delete_requested", self, "on_projectile_delete_requested")
	projectile_instance.delete_requested.connect(on_projectile_delete_requested)
	
func on_projectile_delete_requested(projectile:Node):
	projectile_container.remove_child(projectile)
	projectile.queue_free()
