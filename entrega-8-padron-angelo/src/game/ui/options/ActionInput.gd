tool
extends Node

onready var input = $"%Input"
onready var action = $"%Action"

export (String) var action_input: String setget _set_action_input
export (String) var action_name: String setget _set_action_name

func _ready() -> void:
	input.text = action_input
	action.text = action_name
	
func _set_action_input(input: String) -> void:
	action_input = input
	if Engine.editor_hint && has_node("%Input"):
		$"%Input".text = input

func _set_action_name(name: String) -> void:
	action_name = name
	if Engine.editor_hint && has_node("%Input"):
		$"%Action".text = name
