extends Button

enum EstadoCarta { ABAIXADA, LEVANTADA, ENCONTRADA }

var estado = EstadoCarta.ABAIXADA
var planta_data: PlantaData
var texture_verso = preload("res://Assets/Art/Plantas/card_verso.png")

func _ready():
	configurar_aparencia()

func configurar_aparencia():
	# 🔥 PROPORÇÃO YUGIOH: 1:1.43 (aproximadamente 3:4.3)
	var screen_size = get_viewport().get_visible_rect().size
	
	# Baseamos na altura para manter consistência
	var card_height = screen_size.y * 0.18  # 18% da altura (um pouco maior)
	var card_width = card_height * 0.7      # 🔥 PROPORÇÃO YUGIOH: Largura = 70% da altura
	
	custom_minimum_size = Vector2(card_width, card_height)
	
	# 🔥 CONFIGURAÇÕES VISUAIS MELHORADAS
	expand_icon = true
	icon_alignment = HORIZONTAL_ALIGNMENT_CENTER
	
	# 🔥 BORDA E ESTILO (se disponível)
	if "add_theme_stylebox_override" in self:
		var style_box = StyleBoxFlat.new()
		style_box.bg_color = Color(0.1, 0.1, 0.1, 0.8)  # Fundo escuro semi-transparente
		style_box.border_width_bottom = 4
		style_box.border_width_top = 4
		style_box.border_width_left = 4
		style_box.border_width_right = 4
		style_box.border_color = Color.GOLD
		style_box.corner_radius_top_left = 12
		style_box.corner_radius_top_right = 12
		style_box.corner_radius_bottom_right = 12
		style_box.corner_radius_bottom_left = 12
		add_theme_stylebox_override("normal", style_box)
	
	# 🔥 ESCALA PARA AJUSTE FINO
	var scale_factor = min(card_width / 80.0, card_height / 114.0) * 0.95
	scale = Vector2(scale_factor, scale_factor)
	
	print("🃏 Carta Yugioh - Tamanho: ", custom_minimum_size, " Proporção: ", card_width/card_height)

func aplicar_estado_abaixada():
	estado = EstadoCarta.ABAIXADA
	icon = texture_verso
	mouse_filter = Control.MOUSE_FILTER_STOP

func aplicar_estado_levantada():
	estado = EstadoCarta.LEVANTADA
	icon = planta_data.texture if planta_data else null
	mouse_filter = Control.MOUSE_FILTER_STOP

func aplicar_estado_encontrada():
	estado = EstadoCarta.ENCONTRADA
	icon = planta_data.texture if planta_data else null
	mouse_filter = Control.MOUSE_FILTER_IGNORE

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

var virada: bool:
	get:
		return estado == EstadoCarta.LEVANTADA || estado == EstadoCarta.ENCONTRADA

var match_encontrado: bool:
	get:
		return estado == EstadoCarta.ENCONTRADA
