extends Node2D

export var index: = 0


func _on_Area2D_body_entered(body: Node) -> void:
	var obj: = body as RigidBody2D
	if not obj:
		return
	
	get_node("/root/CheckpointManager").set_checkpoint(self)
