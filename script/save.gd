# Les données à sauvegarder au format JSON
const data = {
	"player":	{
		"position": Vector2(0, 0),
	},
	"world":	{
		"tick": 0,
		"hours": 0,
		"nb_day": 0,
	},
}

# Chemin du fichier de sauvegarde (dans le répertoire du jeu pour le rendre plus accessible mais à changer à la fin)
const save_path = "res://save.json"

# Fonction qui permet de sauvegarder lorsque le joueur quitte le jeu
static func save_on_quit(world_data, player_data):
	# Création d'un objet "File"
	var file = File.new()
	# On affecte file à un fichier en mode écriture
	var isOpen = file.open(save_path, File.WRITE)
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
	if file.file_exists(save_path):
		# Si oui on l'ouvre en mode lecture
		file.open(save_path,File.READ)
		# On récupère les données
		loaded_data = parse_json(file.get_line())
		# On ferme le fichier
		file.close()
	else:
		loaded_data = data
		# Puis on retourne les données
	return loaded_data
