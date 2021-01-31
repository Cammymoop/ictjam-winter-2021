extends Area2D



func _on_KillZone_body_entered(body: Node) -> void:
	#get_parent().respawn()
	body.emit_signal("kill")
	
