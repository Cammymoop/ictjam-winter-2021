extends Sprite

export var bounce_factor: float = 400.0

func _on_Area2D_body_entered(body: Node) -> void:
	var obj := body as RigidBody2D
	if not obj:
		return
	
	obj.linear_velocity.y = 0
	
	var directional_vec = Vector2.UP.rotated(rotation)
	obj.apply_central_impulse(bounce_factor * directional_vec)
	
	if obj.has_method("on_bounce"):
		obj.on_bounce()
	
	var sfx_pick = int(rand_range(0, 3))
	
	match sfx_pick:
		0:
			$BounceSfx.play()
		1:
			$BounceSfx2.play()
		2:
			$BounceSfx3.play()
		_:
			print("???")
