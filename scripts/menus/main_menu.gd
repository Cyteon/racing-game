extends Control

@onready var track_container = $"TabContainer/2/TracksContainer"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	load_settings()
	
	for track in TrackManager.tracks:
		if track.get("hide", false):
			continue
		
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
		print_debug("Could not load config")
	
	# Graphics
	
	Engine.max_fps = config.get_value("graphics", "fps", 0)
	$"TabContainer/3/HBoxContainer/Graphics/FPS/FPS/SpinBox".value = config.get_value("graphics", "fps", 0)
	Globals.show_fps = config.get_value("graphics", "show_fps", false)
	$"TabContainer/3/HBoxContainer/Graphics/ShowFPS/CheckButton".button_pressed = config.get_value("graphics", "show_fps", false)
	
	var msaa
	
	match config.get_value("graphics", "antialiasing", 2):
		0:
			msaa = Viewport.MSAA_DISABLED
		1:
			msaa = Viewport.MSAA_2X
		2:
			msaa = Viewport.MSAA_4X
		3:
			msaa = Viewport.MSAA_8X
	
	get_viewport().msaa_3d = msaa
	$"TabContainer/3/HBoxContainer/Graphics/AA/OptionButton".selected = config.get_value("graphics", "antialiasing", 2)
	
	var shadow_quality
	
	match config.get_value("graphics", "shadow_quality", 2):
		0:
			shadow_quality = RenderingServer.SHADOW_QUALITY_SOFT_VERY_LOW
		1:
			shadow_quality = RenderingServer.SHADOW_QUALITY_SOFT_LOW
		2:
			shadow_quality = RenderingServer.SHADOW_QUALITY_SOFT_MEDIUM
		3:
			shadow_quality = RenderingServer.SHADOW_QUALITY_SOFT_HIGH
		4:
			shadow_quality = RenderingServer.SHADOW_QUALITY_SOFT_ULTRA
	
	RenderingServer.positional_soft_shadow_filter_set_quality(shadow_quality)
	RenderingServer.directional_soft_shadow_filter_set_quality(shadow_quality)
	$"TabContainer/3/HBoxContainer/Graphics/Shadows/OptionButton".selected = config.get_value("graphics", "shadow_quality", 2)
	
	get_viewport().use_taa = config.get_value("graphics", "taa", false)
	$"TabContainer/3/HBoxContainer/Graphics/TAA/CheckButton".button_pressed = config.get_value("graphics", "taa", false)
	
	get_viewport().screen_space_aa = Viewport.SCREEN_SPACE_AA_FXAA if config.get_value("graphics", "fxaa", true) else Viewport.SCREEN_SPACE_AA_DISABLED	
	$"TabContainer/3/HBoxContainer/Graphics/FXAA/CheckButton".button_pressed = config.get_value("graphics", "fxaa", true)
	
	DisplayServer.window_set_vsync_mode(
		DisplayServer.VSYNC_ENABLED if config.get_value("graphics", "vsync", false)
		else DisplayServer.VSYNC_DISABLED
	)
	$"TabContainer/3/HBoxContainer/Graphics/VSync/CheckButton".button_pressed = config.get_value("graphics", "vsync", false)
	
	# Display
	
	DisplayServer.window_set_mode(
		DisplayServer.WINDOW_MODE_FULLSCREEN 
		if config.get_value("display", "fullscreen", true)
		else DisplayServer.WINDOW_MODE_WINDOWED
	)
	$"TabContainer/3/HBoxContainer/Display/FullScreen/CheckButton".button_pressed = config.get_value("display", "fullscreen", true)

	# Sound
	
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), linear_to_db(config.get_value("sound", "volume", 1)))
	$"TabContainer/3/HBoxContainer/Sound/Volume/HSlider".value = config.get_value("sound", "volume", 1)
	$"TabContainer/3/HBoxContainer/Sound/Volume/Label".text = "Volume: %s%%" % (config.get_value("sound", "volume", 1) * 100)

func save_settings() -> void:
	var config = ConfigFile.new()
	config.set_value("graphics", "fps", $"TabContainer/3/HBoxContainer/Graphics/FPS/FPS/SpinBox".value)
	config.set_value("graphics", "show_fps", $"TabContainer/3/HBoxContainer/Graphics/ShowFPS/CheckButton".button_pressed)
	config.set_value("graphics", "antialiasing", $"TabContainer/3/HBoxContainer/Graphics/AA/OptionButton".selected)
	config.set_value("graphics", "shadow_quality", $"TabContainer/3/HBoxContainer/Graphics/Shadows/OptionButton".selected)
	config.set_value("graphics", "taa", $"TabContainer/3/HBoxContainer/Graphics/TAA/CheckButton".button_pressed)
	config.set_value("graphics", "fxaa", $"TabContainer/3/HBoxContainer/Graphics/FXAA/CheckButton".button_pressed)
	config.set_value("graphics", "vsync", $"TabContainer/3/HBoxContainer/Graphics/VSync/CheckButton".button_pressed)
	config.set_value("display", "fullscreen", $"TabContainer/3/HBoxContainer/Display/FullScreen/CheckButton".button_pressed)
	config.set_value("sound", "volume", $"TabContainer/3/HBoxContainer/Sound/Volume/HSlider".value)
	
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
	print_debug("Setting changed, saving")
	save_settings()
