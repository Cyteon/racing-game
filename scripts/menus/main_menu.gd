extends Control

@onready var track_container = $"TabContainer/2/TracksContainer"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	load_settings()
	
	for track in TrackManager.tracks:
		var card = track_container.get_node("TemplateTrack").duplicate()
		
		card.get_node("BG").get_node("VBox").get_node("Image").texture_normal = load("res://assets/images/%s" % track["img"])
		card.get_node("BG").get_node("VBox").get_node("Name").text = track["name"]
		card.get_node("BG").get_node("VBox").get_node("Diff").text = track["difficulty"]
		
		var record = TrackManager.records[track["id"]]["record"]
		card.get_node("BG").get_node("VBox").get_node("Record").text = ("Record: %s:%s.%s" % [int(record / 60), int(record) % 60, int(record*100) % 100]) if record > 0 else "No Record"

		
		card.get_node("BG").get_node("VBox").get_node("Image").pressed.connect(_card_pressed.bind(track))
		card.pressed.connect(_card_pressed.bind(track))
		
		card.visible = true
		track_container.add_child(card)

func load_settings() -> void:
	var config = ConfigFile.new()
	
	var err = config.load("user://settings.cfg")
	
	if err != OK:
		return
	
	Engine.max_fps = config.get_value("graphics", "fps", 0)
	$"TabContainer/3/HBoxContainer/Graphics/FPS/FPS/SpinBox".value = config.get_value("graphics", "fps", 0)
	Globals.show_fps = config.get_value("graphics", "show_fps", false)
	$"TabContainer/3/HBoxContainer/Graphics/ShowFPS/CheckButton".button_pressed = config.get_value("graphics", "show_fps", false)

func save_settings() -> void:
	var config = ConfigFile.new()
	config.set_value("graphics", "fps", $"TabContainer/3/HBoxContainer/Graphics/FPS/FPS/SpinBox".value)
	config.set_value("graphics", "show_fps", $"TabContainer/3/HBoxContainer/Graphics/ShowFPS/CheckButton".button_pressed)
	
	config.save("user://settings.cfg")
	
	load_settings()

func _on_play_button_pressed() -> void:
	$ClickSound.play()
	$TabContainer.current_tab = 1


func _on_credits_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/menus/Credits.tscn")


func _on_exit_button_pressed() -> void:
	get_tree().quit()

func _on_back_button_pressed() -> void:
	$ClickSound.play()
	$TabContainer.current_tab = 0

func _card_pressed(card) -> void:
	if card["id"] == "tutorial":
		get_tree().change_scene_to_file("res://scenes/menus/Tutorial.tscn")
	else:
		get_tree().change_scene_to_file("res://scenes/tracks/%s.tscn" % card["id"])

func _mouse_enter(btn: String) -> void:
	var path = "TabContainer/1/VBoxContainer/%s" % btn
	
	if btn == "BackButton":
		path = "TabContainer/2/BackButton"
	
	var tween = get_tree().create_tween()
	tween.tween_property(get_node(path), "modulate", Color.LIGHT_SKY_BLUE, .5)

func _mouse_exit(btn: String) -> void:
	var path = "TabContainer/1/VBoxContainer/%s" % btn
	
	if btn == "BackButton":
		path = "TabContainer/2/BackButton"
	
	var tween = get_tree().create_tween()
	tween.tween_property(get_node(path), "modulate", Color.WHITE, .5)

func _on_settings_button_pressed() -> void:
	$ClickSound.play()
	$TabContainer.current_tab = 2

func _setting_changed(value) -> void:
	save_settings()
