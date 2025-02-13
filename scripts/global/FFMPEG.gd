extends Node
class_name FFMPEG
## Static class to access FFMPEG

## Converts file at [param path] to `.wav` format. [br]
## Boolean [param delete] sets if original file is deleted or not.
static func convert_to_wav(node : Node,path : String, delete : bool = false) -> String :
	var output := []
	var error := OS.execute("ffmpeg", ["-i", path, path.get_basename() + ".wav"], output, true)
	if error != 0 :
		print(" -- FFMPEG ERROR -- ")
		print(output[0])
		print(" -- FFMPEG END OF ERROR -- ")
		#var error_popup : AcceptDialog = AcceptDialog.new()
		#error_popup.title = "FFMPEG Error"
		#error_popup.dialog_text = "There was an error with FFMPEG. \n\n Stack trace :\n"+output[0]
		#error_popup.ok_button_text = "Dismiss"
		#node.add_child(error_popup)
		#error_popup.show()
	if delete :
		DirAccess.remove_absolute(path)
	print(output[0])
	return path.get_basename() + ".wav"
