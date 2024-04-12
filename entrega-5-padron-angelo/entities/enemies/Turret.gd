extends Sprite2D

@onready var fire_position = $FirePosition
@onready var fire_timer = $FireTimer

@export var projectile_scene:PackedScene

var projectile_container:Node
var target:Node2D

func _ready():
	fire_timer.timeout.connect(fire_at_player)
	
func initialize(container, turret_pos):
	container.add_child(self)
	global_position = turret_pos
	self.projectile_container = container


func fire_at_player():
	var projectile_instance = projectile_scene.instantiate()
	projectile_instance.initialize(projectile_container, fire_position.global_position, fire_position.global_position.direction_to(target.global_position))


func _on_detection_area_body_entered(body):
	if self.target == null:
		self.target = body
		fire_timer.start()
	

func _on_detection_area_body_exited(body):
	if self.target == body:
		self.target = null
		fire_timer.stop()
