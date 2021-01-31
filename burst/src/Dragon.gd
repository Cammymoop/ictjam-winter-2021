extends RigidBody2D

signal kill
signal win

export var red = false

export var game_speed: float = 1.0

export var fire: PackedScene

var boost_force: float = 200.0

var static_boost_force: float = 900.0

var min_static_boost_x_vel: float = 50.0

var can_boost = true
var can_static_boost = true
var buffered_boost = 0

var saved_velocity: Vector2 = Vector2(0, 0)

var static_boost_active = false

var input_enabled = true

# Hack whatever
var death_sprite = preload("res://assets/img/dragon5.png")

func _ready() -> void:
	Engine.time_scale = game_speed
	$Camera2D.current = true
	
	$AnimationPlayer.play("Idle")
	
	if red:
		death_sprite = load("res://assets/img/dragon_red5.png")
		$dragon1.visible = false
		$dragon2.visible = true
	

func _process(_delta: float) -> void:
	if input_enabled:
		if Input.is_action_just_pressed("boost_2"):
			if can_boost and can_static_boost:
				static_boost()
			elif can_static_boost:
				buffered_boost = 2
		if Input.is_action_just_pressed("boost_1"):
			if can_boost:
				boost()
			else:
				buffered_boost = 1

func captured() -> void:
	input_enabled = false
func released() -> void:
	input_enabled = true

func boost() -> void:
	apply_central_impulse(Vector2(1.0, 0) * boost_force)
	$AnimationPlayer.play("Breath")
	
	var pitch = rand_range(1.9, 2.6)
	$FireSfx.pitch_scale = pitch
	$FireSfx.play()
	
	post_boost()

func static_boost() -> void:
	if linear_velocity.x < min_static_boost_x_vel:
		linear_velocity.x = min_static_boost_x_vel
	
	saved_velocity = linear_velocity
	
	linear_velocity = Vector2(0.0, 0.0)
	gravity_scale = 0
	apply_central_impulse(static_boost_force * Vector2.RIGHT)
	$StaticBoostEnd.start()
	
	$AnimationPlayer.play("Breath2")
	if rand_range(0, 1) > 0.5:
		$BlastSfx.play()
	else:
		$BurstSfx.play()
	static_boost_active = true
	can_static_boost = false
	
	$FireRepeater.start()
	
	post_boost()

func post_boost() -> void:
	spawn_fire_effect()
	
	can_boost = false
	$FireReset.start()

func spawn_fire_effect() -> void:
	var effect: Sprite = fire.instance()
	effect.global_position = $FirePosition.global_position
	get_parent().add_child(effect)

func on_bounce() -> void:
	if not can_static_boost:
		can_static_boost = true

func _on_FireReset_timeout() -> void:
	can_boost = true
	
	if buffered_boost == 1:
		boost()
	elif buffered_boost == 2:
		static_boost()
	
	buffered_boost = 0


func _on_StaticBoostEnd_timeout() -> void:
	if not static_boost_active:
		return
	$FireRepeater.stop()
	spawn_fire_effect()
	static_boost_active = false
	linear_velocity = saved_velocity
	gravity_scale = 1


func _on_Dragon_body_entered(_body: Node) -> void:
	if not can_static_boost:
		can_static_boost = true


func _on_FireRepeater_timeout() -> void:
	spawn_fire_effect()


func _on_Dragon_kill() -> void:
	if red:
		$dragon2.texture = death_sprite
	else:
		$dragon1.texture = death_sprite
	$DieSound.play()
	
	get_tree().paused = true
	$DeathReset.start()

func _on_DeathReset_timeout() -> void:
	get_node("/root/GlobalKeys").respawn()


func _on_Dragon_win() -> void:
	$AnimationPlayer.play("Smile")
	$WinMusic.play()
