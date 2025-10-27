class_name GerenciadorPlantas

static func carregar_plantas() -> Array:
	var file_path = "res://Assets/Data/plantas_data.json"
	
	if not FileAccess.file_exists(file_path):
		push_error("❌ Arquivo não encontrado: " + file_path)
		return []
	
	var file = FileAccess.open(file_path, FileAccess.READ)
	if file == null:
		push_error("❌ Erro ao abrir arquivo: " + file_path)
		return []
	
	var json_text = file.get_as_text()
	file.close()
	
	var json = JSON.new()
	var parse_result = json.parse(json_text)
	
	if parse_result != OK:
		push_error("❌ Erro ao parsear JSON: " + json.get_error_message())
		return []
	
	var data = json.get_data()
	var plantas = []
	
	for planta_data in data["plantas"]:
		# Carrega a texture
		var texture = load(planta_data["texture_path"])
		if texture == null:
			push_error("⚠️ Texture não encontrada: " + planta_data["texture_path"])
			continue
		
		# Cria o objeto PlantaData
		var planta = PlantaData.new(
			planta_data["id"],
			planta_data["nome"],
			planta_data["raridade"],
			texture,
			planta_data["descricao"],
			planta_data["regiao"]
		)
		plantas.append(planta)
	
	print("✅ " + str(plantas.size()) + " plantas carregadas do JSON")
	return plantas
