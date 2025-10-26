class_name PlantaData

var id: String
var nome: String
var raridade: String  # COMUM, INCOMUM, RARO
var texture: Texture2D
var descricao: String
var regiao: String

func _init(plant_id: String, plant_nome: String, plant_raridade: String, plant_texture: Texture2D, plant_descricao: String, plant_regiao: String):
	id = plant_id
	nome = plant_nome
	raridade = plant_raridade
	texture = plant_texture
	descricao = plant_descricao
	regiao = plant_regiao
