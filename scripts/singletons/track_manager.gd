extends Node

var tracks = [
	{
		"name": "Tutorial",
		"id": "tutorial",
		"img": "track_tutorial.png",
		"difficulty": "Super Easy"
	},
	{
		"name": "Go Fast",
		"id": "go_fast",
		"img": "track_go_fast.png",
		"difficulty": "Very Easy"
	},
	{
		"name": "Goin Up",
		"id": "going_up",
		"img": "track_going_up.png",
		"difficulty": "Medium"
	},
	{
		"name": "Rainy",
		"id": "rainy",
		"img": "placeholder.jpg",
		"difficulty": "Medium"
	},
	{
		"name": "NEW!!1!",
		"id": "new",
		"img": "track_new.png",
		"difficulty": "Hard"
	},
	{
		"name": "Night",
		"id": "night",
		"img": "track_night.png",
		"difficulty": "Hard"
	},
	{
		"name": "Darkness",
		"id": "darkness",
		"img": "track_darkness.png",
		"difficulty": "Hardcore"
	},
	{
		"name": "Motorcycle?",
		"id": "motorcycle",
		"img": "placeholder.jpg",
		"difficulty": "?????",
		"hide": true
	}
]

var records = {
	# trackid: ....
}

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for track in tracks:
		records[track["id"]] = { "positions": [], "rotations": [], "record": 0 }
