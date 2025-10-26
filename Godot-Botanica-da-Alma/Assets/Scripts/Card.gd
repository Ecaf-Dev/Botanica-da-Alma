extends Button

# Estados da carta
enum EstadoCarta { ABAIXADA, LEVANTADA, ENCONTRADA }

var estado = EstadoCarta.ABAIXADA
var cor: Color
var cor_verso = Color.BLACK  # 🔥 COR PRETA PARA O VERSO

func _ready():
	configurar_aparencia()
	# 🔥 NÃO CHAMA aplicar_estado_abaixada() AQUI - o Grid vai configurar depois

func configurar_aparencia():
	custom_minimum_size = Vector2(64, 64)

# =============================================================================
# FUNÇÕES DE CONTROLE DE ESTADO
# =============================================================================

func aplicar_estado_abaixada():
	estado = EstadoCarta.ABAIXADA
	modulate = cor_verso  # 🔥 MOSTRA VERSO PRETO
	mouse_filter = Control.MOUSE_FILTER_STOP
	print("Carta abaixada - mostrando verso preto")

func aplicar_estado_levantada():
	estado = EstadoCarta.LEVANTADA
	modulate = cor  # 🔥 MOSTRA CONTEÚDO (COR DA PLANTA)
	mouse_filter = Control.MOUSE_FILTER_STOP
	print("Carta levantada - Cor: ", cor)

func aplicar_estado_encontrada():
	estado = EstadoCarta.ENCONTRADA
	modulate = cor  # 🔥 MANTÉM CONTEÚDO VISÍVEL
	mouse_filter = Control.MOUSE_FILTER_IGNORE  # 🔥 NÃO CLICÁVEL
	print("Carta encontrada - Match completo!")
	
# =============================================================================
# FUNÇÕES PÚBLICAS (CHAMADAS PELO GRID)
# =============================================================================

func virar_carta():
	if estado == EstadoCarta.ABAIXADA:
		aplicar_estado_levantada()
	else:
		print("Aviso: Tentou virar carta que já está virada")

func desvirar_carta():
	if estado == EstadoCarta.LEVANTADA:
		aplicar_estado_abaixada()
	else:
		print("Aviso: Tentou desvirar carta não levantada")

func marcar_como_encontrada():
	aplicar_estado_encontrada()

# 🔥 FUNÇÃO PARA O GRID CONFIGURAR A CARTA
func configurar_carta(nova_cor: Color):
	cor = nova_cor
	aplicar_estado_abaixada()  # 🔥 AGORA SIM CONFIGURA O ESTADO INICIAL

# =============================================================================
# FUNÇÕES AUXILIARES
# =============================================================================

func _on_pressed():
	print("Carta clicada - Estado: ", estado)
	
	match estado:
		EstadoCarta.ABAIXADA:
			# Só processa cliques se estiver abaixada
			virar_carta()
		EstadoCarta.LEVANTADA:
			print("Carta já está levantada - clique ignorado")
		EstadoCarta.ENCONTRADA:
			print("Carta já foi encontrada - clique ignorado")

# 🔥 PROPRIEDADE PARA COMPATIBILIDADE COM O GRID EXISTENTE
var virada: bool:
	get:
		return estado == EstadoCarta.LEVANTADA || estado == EstadoCarta.ENCONTRADA

var match_encontrado: bool:
	get:
		return estado == EstadoCarta.ENCONTRADA
