# No Global.gd
extends Node

enum Biomas { FLORESTA, FLORESTA_ENCANTADA }

var dificuldade_selecionada: int = 0 
var bioma_selecionado: Biomas = Biomas.FLORESTA
var bioma_selecionado_provisorio = ""

func preparar_partida(p_dificuldade: int):
	dificuldade_selecionada = p_dificuldade
	# Troca para a cena do minigame
	# Certifique-se de que o caminho abaixo é o real da sua cena
	get_tree().change_scene_to_file("res://Cenas/root.tscn")
