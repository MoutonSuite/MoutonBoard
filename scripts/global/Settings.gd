extends Node
class_name SettingsGlobal
## Autoload to manage settings and all.

const DATA_PATH : String = "user://data.tres"

static var current_settings : SettingsResource
static var data : GlobalData

func _ready() -> void:
	if FileAccess.file_exists(DATA_PATH) :
		data = load(DATA_PATH)
	else :
		data = GlobalData.new()

	if not data.last_used_settings or not FileAccess.file_exists(data.last_used_settings) :
		current_settings = SettingsResource.new()
		current_settings.theme = load("res://assets/themes/basic.theme")
		current_settings.material = load("res://assets/themes/basic.material")
		current_settings.last_soundboard_path = "res://assets/themes/basic.res"
	else :
		current_settings = load(data.last_used_settings)

class SettingsResource extends Resource :
	@export var theme : Theme :
		set(new) :
			theme = new
			if not Settings.is_node_ready():
				await Settings.ready
				Settings.save_settings(Settings.data.last_used_settings)
	@export var material : ShaderMaterial
	@export var last_soundboard_path : String

class GlobalData extends Resource :
	@export var last_used_settings : String :
		set(new) :
			last_used_settings = new
			save_data()

	func save_data() -> Error :
		ResourceSaver.save(self,DATA_PATH)
		return ERR_BUG


static func save_settings(path : String = data.last_used_settings) -> Error :
	var error : Error = ResourceSaver.save(current_settings,path)
	return error

static func load_settings(path : String = data.last_used_settings) -> Error :
	current_settings = load(path)
	return OK
