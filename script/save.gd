# Les données à sauvegarder au format JSON
const data = {
	"player":	{
		"level" : 1,
		"position": Vector2(1000, 100),
	},
	"world":	{
		"tick": 0,
		"hours": 8,
		"nb_day": 0,
	},
	"inventory":	{
		"consommables": [],
		"equipements": [],
	}
}

static func create_save_file(file_name):
	var file = File.new()
	file.open("res://saves/" + file_name + ".json", File.WRITE)
	file.store_line(to_json(data))
	file.close()
	Global.set_save_path(file_name + ".json")


# Fonction qui permet de sauvegarder lorsque le joueur quitte le jeu
static func save_on_quit(world_data, player_data, inventory_data):
	# Création d'un objet "File"
	var file = File.new()
	var isOpen = null
	# On affecte file à un fichier en mode écriture
	if Global.save_file_path == null:
		isOpen = file.open("res://saves/save.json", File.WRITE)
	else:
		isOpen = file.open(Global.save_file_path, File.WRITE)
	# Si tout est ok
	if isOpen == OK:
		# On parcours les données concernant le monde
		for w_keys in world_data:
			# On les stocks dans la variable "data"
			if w_keys in data["world"]:
				data["world"][w_keys] = world_data[w_keys]
		# On parcours les données concernant le joueur
		for p_keys in player_data:
			# On les stocks dans la variable "data"
			if p_keys in data["player"]:
				data["player"][p_keys] = player_data[p_keys]
		# On parcours les données concernant l'inventaire
		for i_keys in inventory_data:
			# On les stocks dans la variables "data"
			if i_keys in data["inventory"]:
				data["inventory"][i_keys] = inventory_data[i_keys]
		# On écrit la variable "data" en JSON dans le fichier
		file.store_line(to_json(data))
		# On ferme le fichier
		file.close()

# Fonction qui permet de charger les données
static func load_data():
	# Création d'un objet "File"
	var file = File.new()
	# Création de la variable qui contiendra les données
	var loaded_data
	# On vérifie que le fichier de sauvegarde existe
	if Global.save_file_path != null and file.file_exists(Global.save_file_path):
		# Si oui on l'ouvre en mode lecture
		file.open(Global.save_file_path,File.READ)
		# On récupère les données
		loaded_data = parse_json(file.get_line())
		# On ferme le fichier
		file.close()
	else:
		loaded_data = data
		# Puis on retourne les données
	return loaded_data
