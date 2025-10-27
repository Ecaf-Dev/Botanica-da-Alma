extends Button

enum EstadoCarta { ABAIXADA, LEVANTADA, ENCONTRADA }

var estado = EstadoCarta.ABAIXADA
var planta_data: PlantaData
var texture_verso = preload("res://Assets/Art/Plantas/card_verso.png")  # 🔥 CRIE ESTE SPRITE

func _ready():
	configurar_aparencia()

func configurar_aparencia():
	custom_minimum_size = Vector2(64, 64)
	expand_icon = true  # 🔥 IMPORTANTE: Faz o icon preencher o botão

func aplicar_estado_abaixada():
	estado = EstadoCarta.ABAIXADA
	icon = texture_verso
	mouse_filter = Control.MOUSE_FILTER_STOP
	print("Carta abaixada - ", planta_data.nome if planta_data else "Sem dados")

func aplicar_estado_levantada():
	estado = EstadoCarta.LEVANTADA
	icon = planta_data.texture if planta_data else null
	mouse_filter = Control.MOUSE_FILTER_STOP
	print("Carta levantada - ", planta_data.nome)

func aplicar_estado_encontrada():
	estado = EstadoCarta.ENCONTRADA
	icon = planta_data.texture if planta_data else null
	mouse_filter = Control.MOUSE_FILTER_IGNORE
	print("Carta encontrada - ", planta_data.nome)

# 🔥 FUNÇÃO PARA CONFIGURAR COM PlantaData
func configurar_com_planta(dados_planta: PlantaData):
	planta_data = dados_planta
	aplicar_estado_abaixada()

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

func _on_pressed():
	print("Carta clicada - Estado: ", estado)
	
	match estado:
		EstadoCarta.ABAIXADA:
			virar_carta()
		EstadoCarta.LEVANTADA:
			print("Carta já está levantada - clique ignorado")
		EstadoCarta.ENCONTRADA:
			print("Carta já foi encontrada - clique ignorado")

# 🔥 PROPRIEDADES PARA COMPATIBILIDADE
var virada: bool:
	get:
		return estado == EstadoCarta.LEVANTADA || estado == EstadoCarta.ENCONTRADA

var match_encontrado: bool:
	get:
		return estado == EstadoCarta.ENCONTRADA
