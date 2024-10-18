@tool
extends Node
class_name ClipButton
## UI class to render a nice little 
## button for each sound clip

@onready var texture_rect : TextureRect = $TextureRect
@onready var color_rect : ColorRect = $ColorRect
@onready var panel : Panel = $Panel
@onready var label : Label = $CenterContainer/Label

@onready var button : Button = $Button
@onready var audio_stream_player : AudioStreamPlayer = $AudioStreamPlayer

@export var clip : SoundClip :
	set(new) :
		clip = new
		if not is_node_ready() :
			await ready
		print("Clip changed !")
		audio_stream_player.stream = new.stream
		audio_stream_player.volume_db = new.volume
		label.text = new.clip_name
		color_rect.color = new.color
		texture_rect.texture = new.icon
		var stylebox : StyleBoxFlat = panel.get_theme_stylebox("normal").duplicate()
		stylebox.border_color = new.color
		panel.add_theme_stylebox_override("normal",stylebox)

func _ready() :
	clip = clip
	button.pressed.connect(play_clip)

func play_clip() :
	audio_stream_player.stream = clip.stream
	audio_stream_player.play()
