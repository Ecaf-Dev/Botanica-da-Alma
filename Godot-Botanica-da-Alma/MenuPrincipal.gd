extends Control


# Called when the node enters the scene tree for the first time.

func _on_iniciar_pressed():
	# 1. Pegamos a referência do botão de dificuldade
	var botao_dif = $BackGround/CenterContainer/VBoxContainer/BotaoDificuldade
	
	# 2. Garantimos que o Global esteja sincronizado com o texto atual
	if botao_dif.text == "Fácil":
		Global.dificuldade_selecionada = 0
	elif botao_dif.text == "Médio":
		Global.dificuldade_selecionada = 1
	elif botao_dif.text == "Difícil":
		Global.dificuldade_selecionada = 2
	
	# 3. Agora sim, mudamos para a cena do jogo
	get_tree().change_scene_to_file("res://Cenas/root.tscn")
	
func _on_sair_pressed():
	get_tree().quit()


func _on_botao_dificuldade_pressed():
	# Adicionei o "BackGround/" no início do caminho conforme sua imagem
	var botao = $BackGround/CenterContainer/VBoxContainer/BotaoDificuldade
	
	if botao.text == "Fácil":
		botao.text = "Médio"
		Global.dificuldade_selecionada = 1
	elif botao.text == "Médio":
		botao.text = "Difícil"
		Global.dificuldade_selecionada = 2
	else:
		botao.text = "Fácil"
		Global.dificuldade_selecionada = 0
