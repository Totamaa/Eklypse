extends Resource
class_name ItemData

enum DAMAGE_TYPE {
	HP,
	MP,
	NULL
}

enum ITEM_TYPE {
	Consommables,
	Equipements
}

export var item_name : String = ""
export var description: String = ""
export(ITEM_TYPE) var item_type: int = ITEM_TYPE.Consommables
export(DAMAGE_TYPE) var damage_type: int = DAMAGE_TYPE.NULL
export var damage : int = 0
# [PROPRIETE]=[+/-][VALEUR];[PROPRIETE]=[+/-][VALEUR] ex: vitesse=+10;force=-5
export var effects: String = ""
export var price : int = -1

export var world_texture : Texture = null
export var inventory_texture : Texture = null
