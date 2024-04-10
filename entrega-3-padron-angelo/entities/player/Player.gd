extends Sprite2D

var speed:float = 200
@onready 
var cannon:Sprite2D = $Cannon # O(log n)
var projectile_container:Node

func set_projectile_container(container:Node):
	cannon.projectile_container = container
	projectile_container = container

func _process(delta):		
	var direction:int = int(Input.is_action_pressed("move_right")) - int(Input.is_action_pressed("move_left"))	
	var mouse_position:Vector2 = get_global_mouse_position()
	
	# Ejemplo calculo de desplazamiento vectorial
	# var origin:Vector2 = global_position
	# var vector_direction:Vector2 = (mouse_position - origin).normalized()
	
	# Manera manual usando propiedad de vectores
	# var mouse_cannon_orientation:Vector2 = mouse_position - cannon.global_position
	# cannon.rotation = mouse_cannon_orientation.angle()
	
	# Utilizando funcion built-in
	cannon.look_at(mouse_position)	
			
	if Input.is_action_just_pressed("fire"):
		cannon.fire()
			
	position.x += direction * speed * delta

