extends Node3D

@export var TRACK_ID: String = ""

var time = 0
var car_positions = []
var car_rotations = []
var run_finished = false

var car_pos_index = 0
var record = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	record = TrackManager.records[TRACK_ID]["record"]
	$CanvasLayer/Control/RecordLabel.text = ("%s:%s.%s" % [int(record / 60), int(record) % 60, int(record*100) % 100]) if record > 0 else "No Record"

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if not run_finished:
		time += delta
		
		if (
			len(TrackManager.records[TRACK_ID]["positions"]) > 0 
			and len(TrackManager.records[TRACK_ID]["positions"]) > car_pos_index
		):
			var pos = TrackManager.records[TRACK_ID]["positions"][car_pos_index]
			pos.y += .3
			$GhostCar.global_position = pos
			$GhostCar.rotation = TrackManager.records[TRACK_ID]["rotations"][car_pos_index]
				
			car_pos_index += 1
		
	car_positions.append($Car.global_position)
	car_rotations.append($Car.rotation)
	
	$CanvasLayer/Control/Label.text = "%s:%s.%s" % [int(time / 60), int(time) % 60, int(time*100) % 100]

func _on_area_3d_body_entered(body: Node3D) -> void:
	$CanvasLayer/Control/EndScreen.visible = true
	run_finished = true
	
	if time < record or record == 0:
		record = time
		TrackManager.records[TRACK_ID]["positions"] = car_positions
		TrackManager.records[TRACK_ID]["rotations"] = car_rotations
		TrackManager.records[TRACK_ID]["record"] = record
	
	await get_tree().create_timer(0.5).timeout
	$Car.freeze = true
	


func _on_play_again_button_pressed() -> void:
	get_tree().reload_current_scene()


func _on_return_to_menu_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/menus/MainMenu.tscn")
