# No Global.gd
extends Node

enum Biomas { FLORESTA, DESERTO, CAMPO, MONTANHA }

var dificuldade_selecionada: int = 0 
var bioma_selecionado: Biomas = Biomas.FLORESTA

func preparar_partida(p_bioma: Biomas, p_dificuldade: int):
	bioma_selecionado = p_bioma
	dificuldade_selecionada = p_dificuldade
	
	# Troca para a cena do minigame
	# Certifique-se de que o caminho abaixo é o real da sua cena
	get_tree().change_scene_to_file("res://Cenas/root.tscn")
