extends Node2D

export (PackedScene) var DragonScene
export var red: = false

var menu_scn = preload("res://scenes/Menu.tscn")

func respawn() -> void:
	get_tree().paused = false
	var checkpoint: Node2D = get_node("/root/CheckpointManager").get_current_checkpoint()
	var dragon = get_node("Dragon")
	dragon.queue_free()
		
	yield(get_tree(), "idle_frame")
	var new_dragon: RigidBody2D = DragonScene.instance()
	new_dragon.red = red
	new_dragon.global_position = checkpoint.global_position
	new_dragon.name = "Dragon"
	add_child(new_dragon)
	

func reset_level() -> void:
	get_tree().paused = false
	#get_tree().reload_current_scene()
	CheckpointManager.reload_scene()

func show_menu() -> void:
	var m: Node = menu_scn.instance()
	
	get_tree().paused = true
	$UI.add_child(m)
