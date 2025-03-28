extends Control
class_name Main
## Main class. Unique.

## Window to edit clips, uses unique class [EditWindow]
@onready var edit_window : EditWindow = $Window

@export var soundboard : SoundBoard = SoundBoard.new()

@onready var load_button : Button = $PanelContainer/MarginContainer/VBoxGrid/HBoxGridSettings/HBoxColumns/ButtonLoad
@onready var save_button : Button = $PanelContainer/MarginContainer/VBoxGrid/HBoxGridSettings/HBoxColumns/ButtonSave
@onready var add_clip_button : Button = $PanelContainer/MarginContainer/VBoxGrid/HBoxGridSettings/HBoxColumns/ButtonNewClip

@onready var columns_spinbox : SpinBox = $PanelContainer/MarginContainer/VBoxGrid/HBoxGridSettings/HBoxColumns/HBoxColumns/SpinBox
@onready var ratio_box : HBoxValue = $PanelContainer/MarginContainer/VBoxGrid/HBoxGridSettings/HBoxColumns/HBoxValue2

@onready var volume_box : HBoxValue = $PanelContainer/MarginContainer/VBoxContainer/HBoxValue

@onready var tab_container : TabContainer = $PanelContainer/MarginContainer/VBoxGrid/TabContainer
@onready var tab_bar : TabBar = $PanelContainer/MarginContainer/VBoxGrid/HBoxTabs/TabBar
@onready var add_tab_button : Button = $PanelContainer/MarginContainer/VBoxGrid/HBoxTabs/AddTabButton

const clip_button_scene : PackedScene = preload("res://scenes/ClipButton.tscn")

func _ready() -> void:
	tab_bar.tab_changed.connect(func (id : int) : tab_container.current_tab = id)
	add_clip_button.pressed.connect(
		func () :
			var current_grid : GridContainer = tab_container.get_child(tab_container.current_tab).get_child(0)
			var new_clip : SoundClip = SoundClip.new()
			var new_button : ClipButton = clip_button_scene.instantiate()
			new_button.clip = new_clip
			current_grid.add_child(new_button)
			edit_window.clip = new_clip
			edit_window.clip_button = new_button
			edit_window.show()
	)
	
