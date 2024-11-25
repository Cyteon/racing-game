extends CanvasLayer

var was_paused: bool = false

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("pause"):
		get_tree().paused = false
		$Control/PauseScreen.visible = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if Globals.show_fps:
		$Control/FPSLabel.visible = true

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("pause") and was_paused:
		get_tree().paused = false
		$Control/PauseScreen.visible = false
	
	was_paused = get_tree().paused
	
	$Control/FPSLabel.text = "%s FPS" % Engine.get_frames_per_second()

func _on_resume_button_pressed() -> void:
	get_tree().paused = false
	$Control/PauseScreen.visible = false


func _on_return_to_menu_button_pressed() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_file("res://scenes/menus/MainMenu.tscn")


func _on_play_again_button_pressed() -> void:
	get_tree().paused = false
	get_tree().reload_current_scene()
