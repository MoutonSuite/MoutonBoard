extends Window
class_name EditWindow
## Unique class for the edit window

@onready var edit_name : LineEdit = $PanelContainer/MarginContainer/VBoxContainer/HBoxName/LineEdit

@onready var color_button : ColorPickerButton = $PanelContainer/MarginContainer/VBoxContainer/HBoxColor/ColorPickerButton

@onready var stream_button : Button = $PanelContainer/MarginContainer/VBoxContainer/VBoxStream/HBoxStream/ButtonPickStream
@onready var file_dialog : NativeFileDialog = stream_button.get_child(0)
@onready var stream_preview : AudioStreamPreview = $PanelContainer/MarginContainer/VBoxContainer/VBoxStream/HBoxPlayer/AudioStreamPreview
@onready var audio_stream_player : AudioStreamPlayer = $PanelContainer/MarginContainer/VBoxContainer/VBoxStream/HBoxPlayer/AudioStreamPlayer
@onready var play_button : Button = $PanelContainer/MarginContainer/VBoxContainer/VBoxStream/HBoxPlayer/Button

@onready var volume_box : HBoxValue = $PanelContainer/MarginContainer/VBoxContainer/HBoxValue
@onready var polyphony_box : HBoxValue =$PanelContainer/MarginContainer/VBoxContainer/HBoxValuePoly

@onready var accept_button : Button = $PanelContainer/MarginContainer/VBoxContainer/HBoxContainer/ButtonAccept
@onready var deny_button : Button = $PanelContainer/MarginContainer/VBoxContainer/HBoxContainer/ButtonDeny


@export var clip : SoundClip = SoundClip.new() :
	set(new) :
		edit_name.text = new.clip_name
		color_button.color = new.color
		if new.stream :
			stream_button.name = new.stream.resource_name
			stream_preview.stream = new.stream
			audio_stream_player.stream = new.stream

		volume_box.value = new.volume

var clip_button : ClipButton

func _ready() -> void:
	close_requested.connect(func () : self.hide())
	deny_button.pressed.connect(func () : self.hide(); clip_button.queue_free(); clip.queue_free())
	accept_button.pressed.connect(func () : self.hide(); Settings.save_settings())

	edit_name.text_changed.connect(func (new:String) : clip.clip_name = new)
	color_button.color_changed.connect(func (new:Color) : clip.color = new)
	
	stream_button.pressed.connect(import_stream)
	play_button.pressed.connect(
		func () :
			if audio_stream_player.is_playing() :
				audio_stream_player.stop()
				play_button.text = "Play"
			else :
				audio_stream_player.play()
				play_button.text = "Stop"
			)
	audio_stream_player.finished.connect(func () : play_button.text = "Play")
	
	file_dialog.file_selected.connect(stream_selected)
	file_dialog.add_filter("*.wav, *.mp3, *.flac, *.ogg", "Supported Audio Format")
	file_dialog.add_filter("*.wav", "Preferred Audio Format (.wav)")
	file_dialog.add_filter("*", "All")
	
	volume_box.value_changed.connect(func (new : float) : clip.volume = new)
	polyphony_box.value_changed.connect(func (new : float) : clip.polyphony = floor(new))

func import_stream() :
	file_dialog.show()

func stream_selected(path : String) :
	print("File selected : ",path)
	if path.get_extension() != "wav" :
		path = FFMPEG.convert_to_wav(self,path)
	if path :
		clip.stream = AudioStreamWAV.load_from_file(path)
		stream_preview.stream = clip.stream
		audio_stream_player.stream = clip.stream
		print("Stream successfully loaded")
