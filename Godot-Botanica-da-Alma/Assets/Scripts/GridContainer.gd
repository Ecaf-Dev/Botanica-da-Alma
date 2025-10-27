extends Node2D

# Configurações
var grid_x = 6
var grid_y = 6
var grid_size = Vector2(grid_x, grid_y)
var card_scene = preload("res://Cenas/Card.tscn")
var card_size = Vector2(80, 80)  # 🔥 AUMENTEI PARA 80x80 PARA CABER SPRITES
var spacing = 10

# Estado do jogo
var carta_selecionada = null
var cliques_travados = false

func _ready():
	criar_grid()

# =============================================================================
# FUNÇÕES DE CONFIGURAÇÃO DO GRID
# =============================================================================

func criar_grid():
	limpar_grid()
	var plantas = gerar_pares_plantas()
	distribuir_cartas(plantas)

func limpar_grid():
	for child in get_children():
		child.queue_free()


func criar_banco_plantas() -> Array:
	var plantas = []
	
	# 🔥 CARREGA SEUS 15 SPRITES OFICIAIS
	var sprites = {
		"raiz_lumina": load("res://Assets/Art/Plantas/raiz_lumina.png"),
		"flor_sussurro": load("res://Assets/Art/Plantas/flor_sussurro.png"),
		"folha_orvalho": load("res://Assets/Art/Plantas/folha_orvalho.png"),
		"cogumelo_brilhante": load("res://Assets/Art/Plantas/cogumelo_brilhante.png"),
		"trevo_lunar": load("res://Assets/Art/Plantas/trevo_lunar.png"),
		"vinha_espinhosa": load("res://Assets/Art/Plantas/vinha_espinhosa.png"),
		"semente_cristal": load("res://Assets/Art/Plantas/semente_cristal.png"),
		"erva_vale": load("res://Assets/Art/Plantas/erva_vale.png"),
		"musgo_antigo": load("res://Assets/Art/Plantas/musgo_antigo.png"),
		"flor_cardinal": load("res://Assets/Art/Plantas/flor_cardinal.png"),
		"raiz_amarga": load("res://Assets/Art/Plantas/raiz_amarga.png"),
		"lirio_noturno": load("res://Assets/Art/Plantas/lirio_noturno.png"),
		"samambaia_prateada": load("res://Assets/Art/Plantas/samambaia_prateada.png"),
		"broto_carvalho": load("res://Assets/Art/Plantas/broto_carvalho.png"),
		"orquidea_selvagem": load("res://Assets/Art/Plantas/orquidea_selvagem.png")
	}
	
	# 🔥 CRIA AS 15 PLANTAS OFICIAIS
	plantas.append(PlantaData.new(
		"raiz_lumina", 
		"Raiz de Lumina", 
		"COMUM", 
		sprites["raiz_lumina"],
		"Uma raiz que brilha suavemente no escuro",
		"FLORESTA"
	))
	
	plantas.append(PlantaData.new(
		"flor_sussurro", 
		"Flor Sussurro", 
		"COMUM", 
		sprites["flor_sussurro"],
		"Emite um sussurro suave ao vento",
		"FLORESTA"
	))
	
	plantas.append(PlantaData.new(
		"folha_orvalho", 
		"Folha de Orvalho", 
		"COMUM", 
		sprites["folha_orvalho"],
		"Conserva gotas de orvalho matinal",
		"FLORESTA"
	))
	
	plantas.append(PlantaData.new(
		"cogumelo_brilhante", 
		"Cogumelo Brilhante", 
		"INCOMUM", 
		sprites["cogumelo_brilhante"],
		"Brilha com uma luz azulada na escuridão",
		"FLORESTA"
	))
	
	plantas.append(PlantaData.new(
		"trevo_lunar", 
		"Trevo Lunar", 
		"RARO", 
		sprites["trevo_lunar"],
		"Só floresce sob a luz da lua cheia",
		"FLORESTA"
	))
	
	plantas.append(PlantaData.new(
		"vinha_espinhosa", 
		"Vinha Espinhosa", 
		"COMUM", 
		sprites["vinha_espinhosa"],
		"Cresce rapidamente e se defende com espinhos",
		"FLORESTA"
	))
	
	plantas.append(PlantaData.new(
		"semente_cristal", 
		"Semente Cristal", 
		"RARO", 
		sprites["semente_cristal"],
		"Brilha como cristal sob a luz do sol",
		"FLORESTA"
	))
	
	plantas.append(PlantaData.new(
		"erva_vale", 
		"Erva do Vale", 
		"COMUM", 
		sprites["erva_vale"],
		"Cresce nos vales mais profundos da floresta",
		"FLORESTA"
	))
	
	plantas.append(PlantaData.new(
		"musgo_antigo", 
		"Musgo Antigo", 
		"COMUM", 
		sprites["musgo_antigo"],
		"Carrega a sabedoria das árvores ancestrais",
		"FLORESTA"
	))
	
	plantas.append(PlantaData.new(
		"flor_cardinal", 
		"Flor Cardinal", 
		"INCOMUM", 
		sprites["flor_cardinal"],
		"Sempre aponta na direção norte",
		"FLORESTA"
	))
	
	plantas.append(PlantaData.new(
		"raiz_amarga", 
		"Raiz Amarga", 
		"INCOMUM", 
		sprites["raiz_amarga"],
		"Tem propriedades medicinais poderosas",
		"FLORESTA"
	))
	
	plantas.append(PlantaData.new(
		"lirio_noturno", 
		"Lírio Noturno", 
		"RARO", 
		sprites["lirio_noturno"],
		"Floresce apenas durante a noite",
		"FLORESTA"
	))
	
	plantas.append(PlantaData.new(
		"samambaia_prateada", 
		"Samambaia Prateada", 
		"INCOMUM", 
		sprites["samambaia_prateada"],
		"Suas folhas refletem a luz como prata",
		"FLORESTA"
	))
	
	plantas.append(PlantaData.new(
		"broto_carvalho", 
		"Broto de Carvalho", 
		"COMUM", 
		sprites["broto_carvalho"],
		"O início de uma grande árvore ancestral",
		"FLORESTA"
	))
	
	plantas.append(PlantaData.new(
		"orquidea_selvagem", 
		"Orquídea Selvagem", 
		"RARO", 
		sprites["orquidea_selvagem"],
		"Rara e bela, encontrada apenas em locais secretos",
		"FLORESTA"
	))
	
	print("🌿 Banco oficial carregado: ", plantas.size(), " plantas")
	return plantas

func gerar_pares_plantas() -> Array:
	var total_cartas = grid_size.x * grid_size.y
	var cartas = []
	
	var banco_plantas = criar_banco_plantas()
	
	# Calcula quantos pares de cada planta
	var cartas_necessarias = total_cartas
	var planta_index = 0
	
	while cartas_necessarias > 0:
		var planta_atual = banco_plantas[planta_index % banco_plantas.size()]
		
		# Adiciona UM par (2 cartas) desta planta
		cartas.append(planta_atual)
		cartas.append(planta_atual)
		
		cartas_necessarias -= 2
		planta_index += 1
	
	print("Total de cartas geradas: ", cartas.size())
	
	# Embaralha
	cartas.shuffle()
	cartas.shuffle()
	
	return cartas

func distribuir_cartas(plantas: Array):
	for i in range(plantas.size()):
		var carta = instanciar_carta()
		configurar_carta(carta, plantas[i], i)

func instanciar_carta():
	var nova_carta = card_scene.instantiate()
	add_child(nova_carta)
	return nova_carta

func configurar_carta(carta, planta_data: PlantaData, indice: int):
	var pos_x = indice % int(grid_size.x)
	var pos_y = indice / int(grid_size.x)
	
	carta.position = Vector2(pos_x * (card_size.x + spacing), pos_y * (card_size.y + spacing))
	
	carta.configurar_com_planta(planta_data)
	
	carta.pressed.connect(_on_carta_pressionada.bind(carta))

# =============================================================================
# FUNÇÕES DE CONTROLE DE CLIQUE
# =============================================================================

func _on_carta_pressionada(carta):
	if cliques_travados or carta.virada or carta.match_encontrado:
		return
	
	if carta_selecionada == null:
		selecionar_primeira_carta(carta)
	else:
		selecionar_segunda_carta(carta)

func selecionar_primeira_carta(carta):
	carta_selecionada = carta
	carta.virar_carta()
	print("Primeira carta selecionada: ", carta.planta_data.nome)

func selecionar_segunda_carta(carta):
	travar_cliques()
	carta.virar_carta()
	
	print("Segunda carta selecionada: ", carta.planta_data.nome)
	await get_tree().create_timer(0.2).timeout
	
	verificar_match(carta)

# =============================================================================
# FUNÇÕES DE LÓGICA DO JOGO
# =============================================================================

func verificar_match(segunda_carta):
	if carta_selecionada.planta_data.id == segunda_carta.planta_data.id:
		processar_match_encontrado(segunda_carta)
	else:
		processar_match_falhou(segunda_carta)

func processar_match_encontrado(segunda_carta):
	print("🎉 MATCH ENCONTRADO! - ", carta_selecionada.planta_data.nome)
	
	carta_selecionada.marcar_como_encontrada()
	segunda_carta.marcar_como_encontrada()
	
	limpar_selecao()
	destravar_cliques()

func processar_match_falhou(segunda_carta):
	print("❌ Não é match: ", carta_selecionada.planta_data.nome, " != ", segunda_carta.planta_data.nome)
	await get_tree().create_timer(0.8).timeout
	
	carta_selecionada.desvirar_carta()
	segunda_carta.desvirar_carta()
	
	limpar_selecao()
	destravar_cliques()

# =============================================================================
# FUNÇÕES AUXILIARES
# =============================================================================

func limpar_selecao():
	carta_selecionada = null

func travar_cliques():
	cliques_travados = true
	print("🔒 Cliques travados")

func destravar_cliques():
	cliques_travados = false
	print("🔓 Cliques destravados")
