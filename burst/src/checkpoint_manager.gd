extends Node

var current_scene = null
var current_checkpoint = null

var scene_path = "res://scenes/Test.tscn"

func get_current_checkpoint() -> Node:
	return current_checkpoint

func _ready() -> void:
	var root = get_tree().get_root()
	current_scene = root.get_child(root.get_child_count() - 1)
	
	GlobalKeys.set_scene(current_scene)
	set_start_checkpoint()

func reload_scene() -> void:
	call_deferred("_deferred_reload_scene")

func load_new_scene(path) -> void:
	scene_path = "res://" + path
	call_deferred("_deferred_reload_scene")

func _deferred_reload_scene() -> void:
	current_scene.free()
	
	var s = ResourceLoader.load(scene_path)
	current_scene = s.instance()
	#get_tree().reload_current_scene()
	get_tree().get_root().add_child(current_scene)
	get_tree().set_current_scene(current_scene)
	
	GlobalKeys.set_scene(current_scene)
	set_start_checkpoint()
	get_tree().paused = false

func set_start_checkpoint() -> void:
	current_checkpoint = current_scene.get_node("StartPoint")

func set_checkpoint(checkpoint) -> void:
	if checkpoint.index > current_checkpoint.index:
		current_checkpoint = checkpoint
