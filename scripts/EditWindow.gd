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

@export var clip : SoundClip = SoundClip.new() :
	set(new) :
		print("hey")

func _ready() -> void:
	close_requested.connect(func () : self.hide())
	stream_button.pressed.connect(import_stream)
	play_button.pressed.connect(audio_stream_player.play)
	
	file_dialog.file_selected.connect(stream_selected)
	file_dialog.add_filter("*.wav, *.mp3, *.flac, *.ogg", "Supported Audio Format")
	file_dialog.add_filter("*.wav", "Preferred Audio Format (.wav)")
	file_dialog.add_filter("*", "All")
	

func import_stream() :
	file_dialog.show()

func stream_selected(path : String) :
	print("File selected : ",path)
	if path.get_extension() != "wav" :
		path = FFMPEG.convert_to_wav(self,path)
	if path :
		var file = FileAccess.open(path, FileAccess.READ)
		var stream_wav : AudioStreamWAV = AudioStreamWAV.new()
		stream_wav.data = file.get_buffer(file.get_length())
		clip.stream = stream_wav
		stream_preview.stream_path = path
		audio_stream_player.stream = clip.stream
		print("Stream successfully loaded")
