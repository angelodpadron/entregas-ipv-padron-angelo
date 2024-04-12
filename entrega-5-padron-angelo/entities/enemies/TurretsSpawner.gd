extends Node

@export var turret_scene:PackedScene

func initialize(player):
	var visible_rect:Rect2 = get_viewport().get_visible_rect()
	for i in 3:
		var turret_instance = turret_scene.instantiate()		
		var turret_pos:Vector2 = Vector2(randf_range(visible_rect.position.x, visible_rect.end.x), randf_range(visible_rect.position.y + 30, player.global_position.y - 50))
		
		turret_instance.initialize(self, turret_pos, player, self)
