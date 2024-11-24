extends VehicleBody3D

@export var ENGINE_POWER: int = 300
@export var MAX_STEER: float = 0.4

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


func _on_audio_stream_player_3d_finished() -> void:
	$AudioStreamPlayer3D.play()
