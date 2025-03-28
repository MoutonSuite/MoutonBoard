@tool
extends Control
class_name ClipButton
## UI class to render a nice little 
## button for each sound clip

@onready var texture_rect : TextureRect = $TextureRect
@onready var color_rect : ColorRect = $ColorRect
@onready var panel : Panel = $Panel
@onready var label : Label = $CenterContainer/Label
@onready var audio_preview : AudioStreamPreview = $AudioStreamPreview
@onready var bar_rect : ColorRect = $BarRect
@onready var bar_cont : Node = $BarContainer

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
		audio_preview.stream = new.stream
		label.text = new.clip_name
		color_rect.color = new.color
		texture_rect.texture = new.icon
		var stylebox : StyleBoxFlat = panel.get_theme_stylebox("normal").duplicate()
		stylebox.border_color = new.color
		panel.add_theme_stylebox_override("normal",stylebox)

func _ready() :
	clip = clip
	button.pressed.connect(play_clip)
	bar_rect.hide()



## Plays sound. Directly calls an [AudioStreamPlayer] in the background, using [method AudioStreamPlayer.play] [br]
## - Arguments [br]
##   - [param arg1] : [Arg1Type] = does this [br]
##   - [param arg2] : [Arg2Type] = does that [br]
## - Outputs the array of whatever the hell as a [PackedStringArray]. [br]
## Pre-conditions : [br]
##   - [param arg1] must be superior to [code]27 - SomeClass.CONSTANT[/code] : [br]
## Post-conditions : [br]

@export_tool_button("Play clip", "Callable") var play_clip_action = play_clip

func play_clip() :
	if audio_stream_player.stream != clip.stream :
		audio_stream_player.stream = clip.stream
	audio_stream_player.play()
	
	var new_bar : ColorRect = bar_rect.duplicate(DUPLICATE_USE_INSTANTIATION)
	new_bar.material = new_bar.material.duplicate()
	new_bar.show()
	bar_cont.add_child(new_bar)
	
	var tween := get_tree().create_tween()
	tween.tween_method(
		(func (value:float) : (new_bar.material as ShaderMaterial).set_shader_parameter("progress",value)),
		0.0,
		1.5,
		clip.stream.get_length()*1.5
	)
	await tween.finished
	new_bar.queue_free()
