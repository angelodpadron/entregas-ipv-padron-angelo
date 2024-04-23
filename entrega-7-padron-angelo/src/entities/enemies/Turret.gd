extends KinematicBody2D
class_name EnemyTurret

onready var fire_position: Node2D = $FirePosition
onready var fire_timer: Timer = $FireTimer
onready var raycast: RayCast2D = $RayCast2D
onready var body_anim: AnimatedSprite = $Body

export (PackedScene) var projectile_scene: PackedScene

export (NodePath) var pathfinding_path: NodePath
onready var pathfinding: PathfindAstar = get_node_or_null(pathfinding_path)

var target: Node2D
var projectile_container: Node

var velocity: Vector2 = Vector2.ZERO

## Flag de ayuda para saber identificar el estado de actividad
var dead: bool = false


func _ready() -> void:
	fire_timer.connect("timeout", self, "fire")
	set_physics_process(false)
	
	## Seteamos la primera animación que debe ejecutarse
	_play_animation("idle")


func initialize(container, turret_pos, projectile_container) -> void:
	container.add_child(self)
	global_position = turret_pos
	self.projectile_container = projectile_container


func fire() -> void:
	if target != null:
		var proj_instance: Node = projectile_scene.instance()
		if projectile_container == null:
			projectile_container = get_parent()
		proj_instance.initialize(
			projectile_container,
			fire_position.global_position,
			fire_position.global_position.direction_to(target.global_position)
		)
		fire_timer.start()
		_play_animation("attack")


func _physics_process(delta: float) -> void:
	raycast.set_cast_to(raycast.to_local(target.global_position))
	if raycast.is_colliding() && raycast.get_collider() == target:
		if fire_timer.is_stopped():
			fire_timer.start()
	elif !fire_timer.is_stopped():
		fire_timer.stop()
	
	## Damos vuelta el cuerpo para que mire al objetivo en el eje x
	## y usamos la dirección a la que se casteó el raycast
	## Otra manera sería hacer (target.global_position - global_position).x < 0
	body_anim.flip_h = raycast.cast_to.x < 0
	
	velocity = move_and_slide(velocity, Vector2.UP)


## Esta función ya no llama directamente a remove, sino que inhabilita las
## colisiones con el mundo, pausa todo lo demás y ejecuta una animación de muerte
## dependiendo de si el enemigo esta o no alerta
func notify_hit() -> void:
	print("I'm turret and imma die")
	dead = true
	target = null
	set_physics_process(false)
	fire_timer.stop()
	collision_layer = 0
	if target != null:
		_play_animation("die_alert")
	else:
		_play_animation("die")


func _remove() -> void:
	get_parent().remove_child(self)
	queue_free()


func _on_DetectionArea_body_entered(body: Node) -> void:
	if target == null && !dead:
		target = body
		set_physics_process(true)
		
		## No se ejecuta directamente el "idle_alert", sino que se ejecuta una
		## animación de transición
		_play_animation("alert")


func _on_DetectionArea_body_exited(body: Node) -> void:
	if body == target && !dead:
		target = null
		set_physics_process(false)
		fire_timer.stop()
		
		## No se ejecuta directamente el "idle", sino que se ejecuta una
		## animación de transición
		_play_animation("go_normal")


## Acá manejamos el callback de "animation finished" y procesamos qué
## lógica ejecutar a continuación, estilo grafo.
func _on_animation_finished() -> void:
	match body_anim.animation:
		"alert":
			_play_animation("idle_alert")
		"go_normal":
			_play_animation("idle")
		"fire", "attack":
			_play_animation("alert")
		"die", "die_alert":
			call_deferred("_remove")


## Wrapper sobre el llamado a animación para tener un solo punto de entrada controlable
## (en el caso de que necesitemos expandir la lógica o debuggear, por ejemplo)
func _play_animation(animation: String) -> void:
	if body_anim.frames.has_animation(animation):
		body_anim.play(animation)
