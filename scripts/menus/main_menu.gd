extends Control

@onready var track_container = $"TabContainer/2/TracksContainer"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for track in TrackManager.tracks:
		var card = track_container.get_node("TemplateTrack").duplicate()
		
		card.get_node("BG").get_node("VBox").get_node("Image").texture_normal = load("res://assets/images/%s" % track["img"])
		card.get_node("BG").get_node("VBox").get_node("Name").text = track["name"]
		card.get_node("BG").get_node("VBox").get_node("Diff").text = track["difficulty"]
		
		card.get_node("BG").get_node("VBox").get_node("Image").pressed.connect(_card_pressed.bind(track))
		card.pressed.connect(_card_pressed.bind(track))
		
		card.visible = true
		track_container.add_child(card)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_play_button_pressed() -> void:
	$TabContainer.current_tab = 1


func _on_credits_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/menus/Credits.tscn")


func _on_exit_button_pressed() -> void:
	get_tree().quit()


func _on_back_button_pressed() -> void:
	$TabContainer.current_tab = 0

func _card_pressed(card) -> void:
	get_tree().change_scene_to_file("res://scenes/tracks/%s.tscn" % card["id"])
