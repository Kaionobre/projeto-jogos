extends Node

# Variável que referencia a scene do Inimigo para instanciar várias cópias
@export var enemy_scene: PackedScene
@export var power_up_scene: PackedScene
@export var bomb_scene: PackedScene

var score
var is_speed_buff_active: bool = false  # Controle para evitar buffs acumulados

func new_game():
	score = 0
	get_tree().call_group("enemy", "queue_free")
	get_tree().call_group("bomb", "queue_free")
	get_tree().call_group("power_up", "queue_free")
	$HUD.update_score(score)
	$HUD.show_message("Get Ready!")
	$Player.start($StartPosition.position)
	$MusicAudio.play()
	$StartTimer.start()
	
func game_over():
	$ScoreTimer.stop()
	$EnemyTimer.stop()
	$HUD.show_game_over()
	$MusicAudio.stop()
	$DeathAudio.play()

func _on_enemy_timer_timeout():
	# Cria uma nova instancia do enemy
	var enemy = enemy_scene.instantiate()
	# adiciona a instancia na scena main
	add_child(enemy)
	# Obtem referencia ao node PathFollow2D
	var enemy_spawn_position = $EnemyPath/EnemySpawnPosition
	# Gera um valor entre 0.0 e 1.0 e atribui ao progress_ratio
	enemy_spawn_position.progress_ratio = randf()
	# Ajusta rotação adicionando 90 graus (Fazendo inimigo olhar para centro da tela)
	var direction = enemy_spawn_position.rotation + PI / 2
	direction += randf_range(-PI / 4, PI / 4)
	
	# Atribui posição ao inimigo
	enemy.position = enemy_spawn_position.position
	# Atribui rotação ao inimigo
	enemy.rotation = direction
	# Define velocidade de movimentação do inimigo
	

	
	var velocity = Vector2(enemy.speed, 0.0)
	enemy.linear_velocity = velocity.rotated(direction)
	

func _on_score_timer_timeout():
	score += 1
	$HUD.update_score(score)
	
	var screen_size = get_viewport().size
	
	if(score % 2 == 0):
		var power_up = power_up_scene.instantiate()
		add_child(power_up)
		power_up.position = Vector2(randi() % screen_size.x, randi() % screen_size.y)
		
	if(score % 2 == 0):
		var bomb = bomb_scene.instantiate()
		add_child(bomb)
		bomb.position = Vector2(randi() % screen_size.x, randi() % screen_size.y)

func _on_start_timer_timeout():
	$EnemyTimer.start()
	$ScoreTimer.start()

func _on_hud_start_game():
	new_game()


func _on_player_power_up():
	if is_speed_buff_active:
		return  # Evita aplicar o buff novamente enquanto está ativo

	is_speed_buff_active = true  # Marca o buff como ativo
	$PowerUpAudio.play()
	$Player.speed *= 1.5
	await get_tree().create_timer(3).timeout
	$Player.speed /= 1.5
	is_speed_buff_active = false  # Marca o buff como inativo

func _on_player_bomb():
	$BombAudio.play()
	get_tree().call_group("enemy", "queue_free")
