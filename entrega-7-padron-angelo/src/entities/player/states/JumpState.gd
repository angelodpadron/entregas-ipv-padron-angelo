extends AbstractState

export (int) var extra_jumps: int = 1

var jumps: int = 0

func jump():
	character.velocity.y -= character.jump_speed
	character._play_animation("jump")

func enter() -> void:
	print("player state: Jump")
	character.snap_vector = Vector2.ZERO
	jump()
	
func exit() -> void:
	jumps = 0
	
func handle_input(event: InputEvent) -> void:
	if event.is_action_pressed("jump") && jumps < extra_jumps:
		jumps += 1
		jump()
	
func update(delta: float) -> void:
	character._handle_weapon_actions()
	character._handle_move_input()		# Estaria bueno que tenga tanta movilidad al estar en el aire
	if character.move_direction == 0:
		character._handle_deacceleration()
	character._apply_movement()
	if character.is_on_floor():
		if character.move_direction == 0:
			emit_signal("finished", "idle")
		else:
			emit_signal("finished", "walk")
		return
		
	if character.velocity.y > 0:
			character._play_animation("fall")
		

func handle_event(event: String, value = null) -> void:
	match event:
		"hit":
			character._handle_hit(value)
			if character.dead:
				emit_signal("finished", "dead")
