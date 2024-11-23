extends Node3D

var time = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	time += delta
	
	$CanvasLayer/Control/Label.text = "%s:%s" % [int(time / 60), int(time) % 60]
