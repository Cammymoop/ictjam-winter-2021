extends Sprite


func _on_Area2D_body_entered(body: Node) -> void:
	var obj: = body as RigidBody2D
	if not obj:
		return
	
	obj.emit_signal("kill")
