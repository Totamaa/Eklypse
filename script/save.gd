const data = {
	"player":	{
		"position": null,
	},
	"ennemie":	{
		"name": "test",
	}
}

const save_path = "res://save.json"


static func save_on_quit(p_data):
	var file = File.new()
	var isOpen = file.open(save_path, File.WRITE)
	if isOpen == OK:
		data["player"]["position"] = p_data["position"]
		data["ennemie"]["name"] = "Gourk"
		file.store_line(to_json(data))
		file.close()

static func load_data():
	var file = File.new()
	var loaded_data
	if file.file_exists(save_path):
		file.open(save_path,File.READ)
		loaded_data = parse_json(file.get_line())
		file.close()
		return loaded_data
