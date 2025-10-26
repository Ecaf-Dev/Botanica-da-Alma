extends Node2D

# Configurações
var grid_x = 4
var grid_y = 4
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
	
	# 🔥 CARREGA SEUS SPRITES - AJUSTE OS CAMINHOS!
	var sprite_planta1 = load("res://Assets/Art/Testes/planta1.png")
	var sprite_planta2 = load("res://Assets/Art/Testes/planta2.png")
	var sprite_planta3 = load("res://Assets/Art/Testes/planta3.png")
	var sprite_planta4 = load("res://Assets/Art/Testes/planta4.png")
	var sprite_planta5 = load("res://Assets/Art/Testes/planta5.png")
	
	# 🔥 CRIA AS PLANTAS COM SEUS SPRITES
	plantas.append(PlantaData.new(
		"planta_1", 
		"Raiz de Lumina", 
		"COMUM", 
		sprite_planta1,
		"Uma raiz que brilha suavemente no escuro",
		"FLORESTA"
	))
	
	plantas.append(PlantaData.new(
		"planta_2", 
		"Flor Sussurro", 
		"COMUM", 
		sprite_planta2,
		"Emite um sussurro suave ao vento",
		"FLORESTA"
	))
	
	plantas.append(PlantaData.new(
		"planta_3", 
		"Trevo Lunar", 
		"RARO", 
		sprite_planta3,
		"Só floresce sob a luz da lua cheia",
		"FLORESTA"
	))
	
	plantas.append(PlantaData.new(
		"planta_4", 
		"Erva do Vale", 
		"COMUM", 
		sprite_planta4,
		"Cresce nos vales mais profundos da floresta",
		"FLORESTA"
	))
	
	plantas.append(PlantaData.new(
		"planta_5", 
		"Cogumelo Brilhante", 
		"INCOMUM", 
		sprite_planta5,
		"Brilha com uma luz azulada na escuridão",
		"FLORESTA"
	))
	
	print("Banco de plantas carregado: ", plantas.size(), " plantas")
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
