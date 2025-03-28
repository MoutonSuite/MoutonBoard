@tool
extends HBoxContainer
class_name HBoxValue
## A composite scene for value selection.

## Value
@export var value : float = 0 :
	set(new) :
		value = new
		value_changed.emit(new)
		if slider and spinbox :
			slider.set_value_no_signal(new)
			spinbox.set_value_no_signal(new)

@onready var label : Label = $Label
@onready var slider : HSlider = $HSlider
@onready var spinbox : SpinBox = $SpinBox

@export var text : String = "Volume" :
	set(new) :
		text = new
		if label :
			label.text = new

@export var suffix : String = "dB" :
	set(new) :
		suffix = new
		if spinbox :
			spinbox.suffix = new

@export var lower_bound : float = -12 :
	set(new) :
		lower_bound = new
		if slider and spinbox :
			slider.min_value = new
			spinbox.min_value = new

@export var higher_bound : float = 10 :
	set(new) :
		higher_bound = new
		if slider and spinbox :
			slider.max_value = new
			spinbox.max_value = new

func _ready() -> void:
	slider.value_changed.connect(_on_change)
	spinbox.value_changed.connect(_on_change)

func _on_change(new) -> void :
	value = new

signal value_changed(new_value : float)
