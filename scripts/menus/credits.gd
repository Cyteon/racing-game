extends Control

# Called when the node enters the scene tree for the first time.
func _ready() -> void:	
	var label = RichTextLabel.new()
	label.size_flags_vertical = Control.SIZE_EXPAND_FILL
	label.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	label.add_theme_font_size_override("normal_font_size", 32)
	
	label.text = "
	This project is licensed under the GNU GPL v3
	Scroll past the GPL license to see the Godot Copyright Information
	Developer: Cyteon
	
	########## Start Other Licenses ##########
	
	-----     Font: Calsans     -----
	Copyright (c) 2021, Mark Davis <mark@designermarkdavis.com> <https://www.designermarkdavis.com>, 
	with Font \"Cal Sans\". Commissioned by Peer Richelsen for Cal.com <https://www.cal.com>.
	See: https://github.com/calcom/font/blob/v1.0.0/OFL.txt
	----- End Font: Calsans -----
	
	########## End Other Licenses  ##########
	
	GNU GPL v3:
	
	"
	
	var file = FileAccess.open("res://LICENSE", FileAccess.READ)
	var content = file.get_as_text()
	
	label.text += content
	
	file = FileAccess.open("res://GODOT_COPYRIGHT.txt", FileAccess.READ)
	content = file.get_as_text()
	
	label.text += "\n\n" + content
	
	$ScrollContainer.add_child(label)

func _on_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/menus/MainMenu.tscn")
