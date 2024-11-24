extends Node

var tracks = [
	{
		"name": "Tutorial",
		"id": "tutorial",
		"img": "placeholder.jpg",
		"difficulty": "Super Easy"
	},
	{
		"name": "Go Fast",
		"id": "go_fast",
		"img": "placeholder.jpg",
		"difficulty": "Very Easy"
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
