class_name GerenciadorTabuleiros

static func carregar_tabuleiro(regiao: String) -> Dictionary:
	var file_path = "res://Assets/Data/tabuleiros_data.json"
	
	if not FileAccess.file_exists(file_path):
		push_error("❌ Arquivo de tabuleiros não encontrado: " + file_path)
		return {}
	
	var file = FileAccess.open(file_path, FileAccess.READ)
	var json_text = file.get_as_text()
	file.close()
	
	var json = JSON.new()
	var parse_result = json.parse(json_text)
	
	if parse_result != OK:
		push_error("❌ Erro ao parsear JSON de tabuleiros: " + json.get_error_message())
		return {}
	
	var data = json.get_data()
	
	if not data["tabuleiros"].has(regiao):
		push_error("❌ Região de tabuleiro não encontrada: " + regiao)
		return {}
	
	var tabuleiro_data = data["tabuleiros"][regiao]
	
	# Carrega a texture do background
	var background_texture = load(tabuleiro_data["background"])
	if background_texture == null:
		push_error("❌ Texture do background não encontrada: " + tabuleiro_data["background"])
		return {}
	
	print("✅ Tabuleiro carregado: " + tabuleiro_data["nome"])
	return {
		"nome": tabuleiro_data["nome"],
		"background_texture": background_texture
	}
