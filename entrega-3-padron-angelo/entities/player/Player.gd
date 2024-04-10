extends Sprite2D

var speed:float = 200
@onready 
var cannon:Sprite2D = $Cannon # O(log n)
var projectile_container:Node

var acceletation:float = 20.0
var horizontal_speed_limit:float = 600.0
var friction_weight:float = 0.1 
var velocity:Vector2 = Vector2.ZERO

func set_projectile_container(container:Node):
	cannon.projectile_container = container
	projectile_container = container

func _process(delta):		
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
		
	# Movimiento y momento
	var direction:int = int(Input.is_action_pressed("move_right")) - int(Input.is_action_pressed("move_left"))	
	
	if direction != 0:
		velocity.x = clamp(velocity.x + (direction * acceletation), -horizontal_speed_limit, horizontal_speed_limit)
	else:
		velocity.x = lerp(velocity.x, 0.0, friction_weight) if abs(velocity.x) > 1 else 0
			
	position += velocity * delta

