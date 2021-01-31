extends Node

var scene_root: Node = null

func set_scene(scene) -> void:
	scene_root = scene

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("reset"):
		scene_root.respawn()
	if Input.is_action_just_pressed("hard_reset"):
		scene_root.reset_level()
	if Input.is_action_just_pressed("menu_button"):
		show_menu()

func show_menu() -> void:
	scene_root.show_menu()

func respawn() -> void:
	scene_root.respawn()
