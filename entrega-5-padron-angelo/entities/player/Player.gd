extends CharacterBody2D

@onready var cannon = $Cannon

@export var ACCELERATION:float = 20.0
@export var H_SPEED_LIMIT:float = 600.0
@export var FRICTION_WEIGHT:float = 0.1
@export var JUMP_SPEED:float = -10.0
@export var GRAVITY:float = 2.0

var projectile_container:Node

func initialize(projectile_container):
	self.projectile_container = projectile_container
	cannon.projectile_container = projectile_container
	
func get_input():
	# Cannon rotation
	var mouse_position:Vector2 = get_global_mouse_position()
	cannon.look_at(mouse_position)
	
	# Cannon fire
	if Input.is_action_just_pressed("fire_cannon"):
		if projectile_container == null:
			projectile_container = get_parent()
			cannon.projectile_container = projectile_container
		cannon.fire()
	
	# Player movement
	var h_movement_direction:int = int(Input.is_action_pressed("move_right")) - int(Input.is_action_pressed("move_left"))
	
	if h_movement_direction != 0:
		velocity.x = clamp(velocity.x + (h_movement_direction * ACCELERATION), -H_SPEED_LIMIT, H_SPEED_LIMIT)
	else:
		velocity.x = lerp(velocity.x, 0.0, FRICTION_WEIGHT) if abs(velocity.x) > 1 else 0
		
	if Input.is_action_just_pressed("jump"):
		velocity.y = JUMP_SPEED
	

func _physics_process(delta):	
	get_input()	
	velocity.y += GRAVITY
	move_and_slide()
