extends Node2D

# Configurações
var grid_x = 0
var grid_y = 0
var grid_size = Vector2(grid_x, grid_y)
var card_scene = preload("res://Cenas/Card.tscn")
var card_size = Vector2(80, 80)
var spacing = 10

# Estado do jogo
var carta_selecionada = null
var cliques_travados = false
var background_node: ColorRect

# Controle de dificuldade - ESCOLHA UMA DAS OPÇÕES ABAIXO:

# 🔥 OPÇÃO 1: Usando ENUM (Recomendado)
enum EstadoDificuldade { FACIL, MEDIO, DIFICIL }
var dificuldade_atual: EstadoDificuldade = EstadoDificuldade.FACIL

func _ready():
	dificuldade_atual = Global.dificuldade_selecionada as EstadoDificuldade
	
	carregar_background()
	definir_tamanho_do_grid_enum()  # 🔥 CHAMA A VERSÃO COM ENUM
	calcular_tamanho_dinamico()
	criar_grid()

# =============================================================================
# FUNÇÕES DE CONFIGURAÇÃO DO GRID
# =============================================================================

func criar_grid():
	limpar_grid()
	var plantas = gerar_pares_plantas()
	distribuir_cartas(plantas)

# 🔥 VERSÃO COM ENUM (Recomendado)
func definir_tamanho_do_grid_enum():
	match dificuldade_atual:
		EstadoDificuldade.FACIL:
			grid_x = 4
			grid_y = 4
		EstadoDificuldade.MEDIO:
			grid_x = 6
			grid_y = 6
		EstadoDificuldade.DIFICIL:
			grid_x = 8
			grid_y = 8
	
	grid_size = Vector2(grid_x, grid_y)
	print("🎯 Dificuldade: ", dificuldade_atual, " - Grid: ", grid_size)

# 🔥 FUNÇÃO PARA MUDAR DIFICULDADE DURANTE O JOGO
func mudar_dificuldade(nova_dificuldade: EstadoDificuldade):
	dificuldade_atual = nova_dificuldade
	definir_tamanho_do_grid_enum()
	# Se quiser recriar o grid automaticamente:
	# criar_grid()

func limpar_grid():
	for child in get_children():
		child.queue_free()

func criar_banco_plantas() -> Array:
	return GerenciadorPlantas.carregar_plantas()
	
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

	var offset_x = get_meta("offset_x", 0)
	var offset_y = get_meta("offset_y", 0)

	# Calcula o tamanho do grid visível (80% da tela)
	var screen_size = get_viewport().get_visible_rect().size
	var grid_width = screen_size.x * 0.8
	var grid_height = screen_size.y * 0.8

	var slot_width = grid_width / grid_size.x
	var slot_height = grid_height / grid_size.y

	# 🔥 Ajuste automático da escala da carta
	var carta_base_size = Vector2(80, 80) # tamanho original da cena Card.tscn
	var escala_slot_x = slot_width / carta_base_size.x
	var escala_slot_y = slot_height / carta_base_size.y
	var escala_final = min(escala_slot_x, escala_slot_y) * 0.7  # 0.85 = 85% do tamanho máximo
	carta.scale = Vector2(escala_final, escala_final)

	# Calcula o tamanho real da carta após a escala
	var carta_real_width = carta_base_size.x * escala_final
	var carta_real_height = carta_base_size.y * escala_final

	# Calcula o centro de cada slot
	var slot_center_x = offset_x + pos_x * slot_width + slot_width / 2
	var slot_center_y = offset_y + pos_y * slot_height + slot_height / 2

	# 🔥 Centraliza a carta exata no centro do slot
	carta.position = Vector2(
		slot_center_x - carta_real_width / 2,
		slot_center_y - carta_real_height / 2
	)

	carta.configurar_com_planta(planta_data)
	carta.pressed.connect(_on_carta_pressionada.bind(carta))

# =============================================================================
# SISTEMA DINÂMICO
# =============================================================================
func calcular_tamanho_dinamico():
	var screen_size = get_viewport().get_visible_rect().size

	# Define o tamanho total do grid (usaremos 80% da tela)
	var grid_width = screen_size.x * 0.8
	var grid_height = screen_size.y * 0.8

	# Calcula o tamanho de cada célula (slot)
	var slot_width = grid_width / grid_size.x
	var slot_height = grid_height / grid_size.y

	# Define o tamanho das cartas (levemente menor que o slot, para sobrar espaçamento)
	var margem = 0.1 # 10% de folga dentro de cada slot
	card_size.x = slot_width * (1 - margem)
	card_size.y = slot_height * (1 - margem)

	# Define o espaçamento (diferença entre slots e cartas)
	spacing = min(slot_width * margem, slot_height * margem)

	# Centraliza o grid inteiro na tela
	var offset_x = (screen_size.x - grid_width) / 2
	var offset_y = (screen_size.y - grid_height) / 2
	set_meta("offset_x", offset_x)
	set_meta("offset_y", offset_y)

	# Cria ou atualiza um background visível para debug
	var grid_bg := get_node_or_null("GridBackground")
	if not grid_bg:
		grid_bg = ColorRect.new()
		grid_bg.name = "GridBackground"
		add_child(grid_bg)
		move_child(grid_bg, 0) # Fica atrás das cartas

	grid_bg.color = Color(0, 0.4, 1, 0.25) # azul translúcido
	grid_bg.position = Vector2(offset_x, offset_y)
	grid_bg.size = Vector2(grid_width, grid_height)

	print("🟦 Grid calculado:")
	print("   Grid Size:", grid_size)
	print("   Grid Dimensões:", Vector2(grid_width, grid_height))
	print("   Slot Size:", Vector2(slot_width, slot_height))
	print("   Carta Size:", card_size)
	print("   Offset:", Vector2(offset_x, offset_y))

	

func ajustar_grid_para_tela(screen_size: Vector2):
	# 🔥 CALCULA CONSIDERANDO PROPORÇÃO YUGIOH
	var max_colunas = floor((screen_size.x - spacing) / (card_size.x + spacing))
	var max_linhas = floor((screen_size.y * 0.75) / (card_size.y + spacing))
	
	# Limita o grid mas mantém pelo menos 2x2
	grid_size.x = max(2, min(grid_size.x, max_colunas))
	grid_size.y = max(2, min(grid_size.y, max_linhas))
	
	print("   Máximo na tela: ", Vector2(max_colunas, max_linhas))

func carregar_background():
	background_node = get_node("../BackGround") as ColorRect
	
	if background_node:
		var tabuleiro_data = GerenciadorTabuleiros.carregar_tabuleiro("floresta")
		if not tabuleiro_data.is_empty():
			# Cria TextureRect como filho do ColorRect
			var texture_rect = TextureRect.new()
			texture_rect.texture = tabuleiro_data["background_texture"]
			texture_rect.expand_mode = TextureRect.EXPAND_FIT_WIDTH_PROPORTIONAL
			texture_rect.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_COVERED
			texture_rect.size = background_node.size
			texture_rect.position = Vector2.ZERO
			
			# Remove anterior se existir
			var old_texture = background_node.get_node_or_null("BackgroundTexture")
			if old_texture:
				old_texture.queue_free()
			
			texture_rect.name = "BackgroundTexture"
			background_node.add_child(texture_rect)
			print("🎨 Background aplicado: ", tabuleiro_data["nome"])

# =============================================================================
# LÓGICA DO JOGO (PERMANECE IGUAL)
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

func limpar_selecao():
	carta_selecionada = null

func travar_cliques():
	cliques_travados = true
	print("🔒 Cliques travados")

func destravar_cliques():
	cliques_travados = false
	print("🔓 Cliques destravados")
