extends Node2D

var captured: RigidBody2D

var launch_loading = false

var min_vel: float = 10.0
var min_delta: float = 2.0

var def_lin_damp: = 3.0
var strong_lin_damp: = 15.0

export var launch_force: float = 360.0

var grab_effect_bus = 0

var release_protection = false

func _ready() -> void:
	min_vel = min_vel * min_vel
	min_delta = min_delta * min_delta
	
	grab_effect_bus = AudioServer.get_bus_index("grabby")

func _process(delta: float) -> void:
	if not captured or not launch_loading:
		return
	
	var pos_delta = (captured.global_position - global_position).length_squared()
	var velocity_magnitude = captured.linear_velocity.length_squared()
	
	if Input.is_action_just_pressed("ui_down"):
		print("V: " + str(velocity_magnitude))
		print("P: " + str(pos_delta))
	
	if pos_delta < min_delta and velocity_magnitude < min_vel:
		launch_obj()
	elif pos_delta < min_delta:
		$Attractor.linear_damp = strong_lin_damp

func launch_obj() -> void:
	launch_loading = false
	$Attractor.space_override = Area2D.SPACE_OVERRIDE_DISABLED
	
	captured.linear_velocity = Vector2(0.0, 0.0)
	release_protection = true
	$RPTimer.start() # fix a bug where it thinks it got released and re-entered when I set the position
	captured.global_position = global_position
	
	captured.gravity_scale = 0
	
	$LaunchCountdown.start()
	#print('stopping sfx')
	$GrabSfx.stop()

func _on_LaunchCountdown_timeout() -> void:
	captured.apply_central_impulse(Vector2(0.5, -1.0) * launch_force)
	captured.gravity_scale = 1
	$LaunchSfx.play()
	$Reset.start()
	




func _on_Attractor_body_entered(body: Node) -> void:
	if release_protection:
		return
	var obj: = body as RigidBody2D
	if not obj:
		return
	
	captured = obj
	launch_loading = true
	
	if obj.has_method("captured"):
		obj.captured()
	
	$GrabSfx.play()


func _on_Attractor_body_exited(body: Node) -> void:
	if release_protection:
		return
	var obj: = body as RigidBody2D
	if not obj:
		return
	
	if captured.has_method("released"):
		captured.released()
	captured = null
	$GrabSfx.stop()


func _on_Reset_timeout() -> void:
	$Attractor.space_override = Area2D.SPACE_OVERRIDE_REPLACE
	$Attractor.linear_damp = def_lin_damp
	$GrabSfx.stop()


func _on_RPTimer_timeout() -> void:
	release_protection = false


func alt_callback_win_level() -> void:
	captured.emit_signal("win")
