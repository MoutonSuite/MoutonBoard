@tool
extends Resource
class_name SoundClip
## Generic class to store the soundboard clips. [br]

## Name of the clip.
@export var clip_name : String = "New Clip"

## Color to caracterise the clip. [br]
## If [member icon] exists, it will be used as the background instead of the color.
@export var color : Color = Color.LIGHT_GRAY

## Image to caracterise the clip. [br]
## If not used, [member color] will be used as the background.
@export var icon : Texture2D

## Sound of the clip, in WAV format.
@export var stream : AudioStreamWAV

## Volume of the clip, in decibels
@export var volume : float = 0.0

## Loop mode for the clip, disabled by default. [br]
## Uses [enum AudioStreamWAV.LoopMode]
@export var loop_mode : AudioStreamWAV.LoopMode = AudioStreamWAV.LoopMode.LOOP_DISABLED
