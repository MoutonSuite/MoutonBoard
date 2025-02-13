extends Resource
class_name SoundBoard
## Generic soundboard resource. [br]
## Allows the user to save and load premade soundboards.

## Soundboard name, to avoid using the resource name for easier saving.
@export var board_name := "New Board"

## Soundboard name, to avoid using the resource name for easier saving.
@export var clips : Array[SoundClip] = []
