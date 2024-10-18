@tool
extends Resource
class_name SoundClip
## Generic class to store the soundboard clips. [br]

## Name of the clip.
@export var clip_name : String = "New Clip"

## Color to caracterise the clip. [br]
## If [member image] exists, it will be used as the background instead of the color.
@export var color : Color = Color.LIGHT_GRAY

## Image to caracterise the clip. [br]
## If not used, [member color] will be used as the background.
@export var icon : Texture2D

## Sound of the clip
@export var stream : AudioStream

## Volume of the clip, in decibels
@export var volume : float = 0.0
