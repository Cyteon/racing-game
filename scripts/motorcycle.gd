extends VehicleBody3D

@export var ENGINE_POWER: int = 300
@export var MAX_STEER: float = .4
@export var DRIFT_MULTIPLIER: float = .4

var steer_lean: bool = false
var grounded: bool = false

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("flip"):
		rotation = Vector3.ZERO
	
	if event.is_action("drift"):
		var lateral_velocity = global_transform.basis.x * global_transform.basis.x.dot(linear_velocity)
		apply_impulse(-lateral_velocity * DRIFT_MULTIPLIER)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:	
	if get_parent().run_started:
		engine_force = Input.get_axis("backward", "forward") * ENGINE_POWER
		
		if engine_force == 0:
			var tween = get_tree().create_tween()
			tween.tween_property($AudioStreamPlayer3D, "volume_db", -20, .5)
		else:
			var tween = get_tree().create_tween()
			tween.tween_property($AudioStreamPlayer3D, "volume_db", -10, .5)
			
	
	steering = move_toward(steering, Input.get_axis("right", "left") * MAX_STEER, delta * 10)
	var hor_input = -Input.get_axis("right", "left")
	
	if steering == 0:
		var dir = -1 if angular_velocity.y > 0 else 1
		
		$VehicleWheel3D/Wheel.rotation.z += dir * delta * -linear_velocity.length() / 2
		$VehicleWheel3D2/Wheel.rotation.z += dir * delta * -linear_velocity.length() / 2
	
	if $VehicleWheel3D.is_in_contact() or $VehicleWheel3D2.is_in_contact():
		grounded = true
	else:
		grounded = false
		
	if grounded:
		if steer_lean:
			angular_velocity = lerp(angular_velocity, -transform.basis.z * hor_input, 0.1)
		elif abs(rotation_degrees.z) >= 1:
			angular_velocity = lerp(angular_velocity, -transform.basis.z * sign(rotation_degrees.z), 0.1)
		else:
			angular_velocity.x = 0
			angular_velocity.z = 0

func _on_audio_stream_player_3d_finished() -> void:
	$AudioStreamPlayer3D.play()
