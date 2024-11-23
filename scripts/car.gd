extends VehicleBody3D

@export var ENGINE_POWER: int = 300
@export var MAX_STEER: float = 0.4

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	engine_force = Input.get_axis("backward", "forward") * ENGINE_POWER
	steering = move_toward(steering, Input.get_axis("right", "left") * MAX_STEER, delta * 10)
