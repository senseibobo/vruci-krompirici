extends Node


func save_to_file(dictionary: Dictionary, file_path: String):
	var file = File.new()
	var error = file.open(file_path, File.WRITE)
	if error == OK:
		file.store_string(JSON.print(dictionary))
		file.close()
	else:
		push_error("Error saving to file, error code: " + str(error))
		file.close()
		return error
	file.close()
	return OK

func load_from_file(file_path: String):
	var file = File.new()
	var error = file.open(file_path, File.READ)
	if error != OK: return error
	var json = JSON.parse(file.get_as_text())
	if json.error != OK: 
		file.close()
		return json.error
	file.close()
	return json.result

	
