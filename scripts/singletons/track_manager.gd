extends Node

var tracks = [
	{
		"name": "Tutorial",
		"id": "tutorial",
		"img": "placeholder.jpg",
		"difficulty": "Super Easy"
	},
	{
		"name": "Goin Up",
		"id": "going_up",
		"img": "placeholder.jpg",
		"difficulty": "Medium"
	}
]

var records = {
	# trackid: ....
}

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for track in tracks:
		records[track["id"]] = { "positions": [], "rotations": [], "record": 0 }

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
