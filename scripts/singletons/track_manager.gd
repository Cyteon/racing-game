extends Node

var tracks = [
	{
		"name": "Tutorial",
		"id": "tutorial",
		"img": "track_basic.jpg",
		"difficulty": "Super Easy"
	},
	{
		"name": "Basic2",
		"id": "basic2",
		"img": "tracK_basic.jpg",
		"difficulty": "Easy"
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
