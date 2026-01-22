extends Control

@onready var popup = $"CanvasLayer/CenterContainer/PanelContainer(PopUp_Dificuldade)"
# Called when the node enters the scene tree for the first time.
func _ready():
	popup.hide()

func _on_texture_button_floresta_encantada_pressed():
	popup.show()
	Global.Biomas.FLORESTA_ENCANTADA
	Global.bioma_selecionado_provisorio = "FLORESTAENCANTANDA"

func _on_button_fechar_pressed():
	popup.hide() # Replace with function body.


func _on_button_facil_pressed():
	# Passa o bioma (ex: Floresta) e a dificuldade 0 (Fácil)
	Global.preparar_partida(0)


func _on_button_medio_pressed():
	Global.preparar_partida(1)


func _on_button_dificil_pressed():
	Global.preparar_partida(2)


func _on_texture_button_floresta_pressed():
	popup.show()
	Global.Biomas.FLORESTA
	Global.bioma_selecionado_provisorio = "FLORESTA"
