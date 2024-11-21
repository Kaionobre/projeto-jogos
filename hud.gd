extends CanvasLayer

signal start_game

func show_message(text):
	$MessageLabel.text = text
	$MessageLabel.show()
	$MessageTimer.start()
	
func update_score(score):
	$ScoreLabel.text = str(score)

func _on_start_button_pressed():
	$StartButton.hide()
	start_game.emit()
	
func show_game_over():
	# Exibe mensagem de GameOver e espera 2 segundos
	show_message("Game Over!")
	await $MessageTimer.timeout
	
	#Exibe título do jogo
	$MessageLabel.text = "Dodge The Creeps"
	$MessageLabel.show()
	
	#Mostra novamente botão de iniciar
	$StartButton.show()

func _on_message_timer_timeout():
	$MessageLabel.hide()
