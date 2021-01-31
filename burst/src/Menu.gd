extends Control

func _ready() -> void:
	var m_id = AudioServer.get_bus_index("Master")
	var muted = AudioServer.is_bus_mute(m_id)
	if muted:
		var toggle = get_node("PanelContainer/VBoxContainer/HBoxContainer2/CheckButton")
		toggle.pressed = false

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("menu_button"):
		menu_close()

func menu_close() -> void:
	get_tree().paused = false
	queue_free()


func _on_Button_pressed() -> void:
	menu_close()


func _on_Button2_pressed() -> void:
	CheckpointManager.load_new_scene("scenes/Test.tscn")


func _on_Button3_pressed() -> void:
	CheckpointManager.load_new_scene("scenes/HardLevel.tscn")


func _on_Button4_pressed() -> void:
	get_tree().quit()


func _on_CheckButton_toggled(sound_enabled: bool) -> void:
	var m_id = AudioServer.get_bus_index("Master")
	AudioServer.set_bus_mute(m_id, not sound_enabled)
