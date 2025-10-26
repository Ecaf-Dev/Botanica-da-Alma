extends Node2D

# Configurações
var grid_x = 6  # 🔥 RENOMEADO: grid_x em vez de x
var grid_y = 6  # 🔥 RENOMEADO: grid_y em vez de y
var grid_size = Vector2(grid_x, grid_y)
var card_scene = preload("res://Cenas/Card.tscn")
var card_size = Vector2(64, 64)
var spacing = 16

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
	var cores = gerar_pares_cores()
	distribuir_cartas(cores)

func limpar_grid():
	for child in get_children():
		child.queue_free()

func gerar_pares_cores() -> Array:
	var total_cartas = grid_size.x * grid_size.y
	var pares = []
	
	var cores_base = [Color.RED, Color.BLUE, Color.GREEN, Color.YELLOW]
	
	var cartas_necessarias = total_cartas
	var pares_por_cor = {}
	
	var cor_index = 0
	while cartas_necessarias > 0:
		var cor_atual = cores_base[cor_index % cores_base.size()]
		
		if not pares_por_cor.has(cor_atual):
			pares_por_cor[cor_atual] = 0
		
		pares.append(cor_atual)
		pares.append(cor_atual)
		pares_por_cor[cor_atual] += 1
		
		cartas_necessarias -= 2
		cor_index += 1
	
	print("Distribuição de pares: ", pares_por_cor)
	
	pares.shuffle()
	pares.shuffle()
	
	print("Total de cartas geradas: ", pares.size())
	return pares

func distribuir_cartas(cores: Array):
	for i in range(cores.size()):
		var carta = instanciar_carta()  # 🔥 REMOVIDOS PARÂMETROS NÃO USADOS
		configurar_carta(carta, cores[i], i)

func instanciar_carta():  # 🔥 REMOVIDOS PARÂMETROS NÃO USADOS
	var nova_carta = card_scene.instantiate()
	add_child(nova_carta)
	return nova_carta

func configurar_carta(carta, cor: Color, indice: int):
	# 🔥 CONVERTE grid_size.x PARA INT para evitar erro com float
	var pos_x = indice % int(grid_size.x)
	var pos_y = indice / int(grid_size.x)
	
	carta.position = Vector2(pos_x * (card_size.x + spacing), pos_y * (card_size.y + spacing))
	
	carta.cor = cor
	carta.aplicar_estado_abaixada()
	
	carta.pressed.connect(_on_carta_pressionada.bind(carta))

# =============================================================================
# RESTANTE DO CÓDIGO (PERMANECE IGUAL)
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
	print("Primeira carta selecionada")

func selecionar_segunda_carta(carta):
	travar_cliques()
	carta.virar_carta()
	
	print("Segunda carta selecionada - verificando match...")
	await get_tree().create_timer(0.2).timeout
	
	verificar_match(carta)

func verificar_match(segunda_carta):
	if carta_selecionada.cor == segunda_carta.cor:
		processar_match_encontrado(segunda_carta)
	else:
		processar_match_falhou(segunda_carta)

func processar_match_encontrado(segunda_carta):
	print("🎉 MATCH ENCONTRADO!")
	
	desativar_carta(carta_selecionada)
	desativar_carta(segunda_carta)
	
	limpar_selecao()
	destravar_cliques()

func processar_match_falhou(segunda_carta):
	print("❌ Não é match - virando de volta...")
	await get_tree().create_timer(0.8).timeout
	
	virar_carta_volta(carta_selecionada)
	virar_carta_volta(segunda_carta)
	
	limpar_selecao()
	destravar_cliques()

func desativar_carta(carta):
	carta.match_encontrado = true
	carta.mouse_filter = Control.MOUSE_FILTER_IGNORE

func virar_carta_volta(carta):
	carta.desvirar_carta()

func limpar_selecao():
	carta_selecionada = null

func travar_cliques():
	cliques_travados = true
	print("🔒 Cliques travados")

func destravar_cliques():
	cliques_travados = false
	print("🔓 Cliques destravados")
