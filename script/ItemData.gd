extends Resource
class_name ItemData

enum EFFECT_TYPE {
	HP,
	NULL
}

enum ITEM_TYPE {
	Consommables,
	Equipements
}

export var item_name : String = ""
export var description: String = ""
export(EFFECT_TYPE) var effect_type: int = EFFECT_TYPE.HP
export(ITEM_TYPE) var item_type: int = ITEM_TYPE.Consommables
export var recover : int = 0
# [PROPRIETE]=[+/-][VALEUR];[PROPRIETE]=[+/-][VALEUR] ex: vitesse=+10;force=-5
export var effects: String = ""
export var price : int = -1

export var world_texture : Texture = null
export var inventory_texture : Texture = null
