extends Resource
class_name CompleteTheme

## Application theme.
@export var theme : Theme = Theme.new()

## Background shader used by the application. If [code]null[/code], defaults to PanelContainer Stylebox.
@export var background_shader : ShaderMaterial