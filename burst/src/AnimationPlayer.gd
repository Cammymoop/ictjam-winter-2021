extends AnimationPlayer


func _on_AnimationPlayer_animation_finished(anim_name: String) -> void:
	if anim_name != "Idle":
		play("Idle")
	
	if anim_name == "Smile":
		GlobalKeys.show_menu()
