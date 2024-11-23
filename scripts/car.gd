extends VehicleBody3D

@export var ENGINE_POWER = 300
@export var MAX_STEER = 0.4
@export var BRAKE_FORCE = 10

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	engine_force = Input.get_axis("backward", "forward") * ENGINE_POWER
	steering = move_toward(steering, Input.get_axis("right", "left") * MAX_STEER, delta * 10)
	
	if Input.is_action_pressed("handbrake"):
		engine_force = 0
		brake = BRAKE_FORCE
	
