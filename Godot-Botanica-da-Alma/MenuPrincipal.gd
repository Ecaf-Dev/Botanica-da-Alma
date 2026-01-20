extends Control


# Called when the node enters the scene tree for the first time.

func _on_iniciar_pressed():
	# Substitua pelo caminho da sua cena principal de jogo
	get_tree().change_scene_to_file("res://Cenas/root.tscn")

func _on_sair_pressed():
	get_tree().quit()
