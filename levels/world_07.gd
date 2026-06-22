extends Node2D

var deslocamento = 370

var ativar_lenhador = false
var lenhador_na_posicao = false

var contador = 0
var velocidade = 2

var diferenca = 0
var dano_sofrido = false
var martelada = false

var vida_inimigo = 100
var urso_nasceu = false
var fim_game = false

func calcular_diferenca_player_lenhador():
	var playerX = $player.position.x - deslocamento
	
	if $lenhador.position.x > 0 and playerX > 0:
		diferenca = $lenhador.position.x - playerX
	elif $lenhador.position.x < 0 and playerX < 0:
		diferenca = ($lenhador.position.x * -1) - (playerX * -1)
	elif $lenhador.position.x > 0 and playerX < 0:
		diferenca = $lenhador.position.x + (playerX * -1)
	elif $lenhador.position.x < 0 and playerX > 0:
		diferenca = ($lenhador.position.x * -1) + playerX
		
	if diferenca < 0:
		diferenca *= -1

func cool_down():
	await get_tree().create_timer(1).timeout
	dano_sofrido = false


func _ready():
	$lenhador.visible = false
	$lenhador/mao_jogando_bixo.visible = false
	$lenhador/DanoUrso.visible = false

func _process(delta):	
	if fim_game:
		get_tree().change_scene_to_file("res://levels/parabens_vc_ganhou.tscn")
	
	# __surgir o lenhador
	if ativar_lenhador and not lenhador_na_posicao:
		if $lenhador.position.y  > 167:
			contador += 1
			$lenhador.position.y -= 1
			if contador == 50:
				$lenhador.position.y += 10
				contador = 0
		else:
			lenhador_na_posicao = true
			contador = 0
	
	# __lenhador perseguindo a raposinha sapeca
	elif lenhador_na_posicao:
		calcular_diferenca_player_lenhador()
		#$lenhador.position.x = $player.position.x - deslocamento #debug
		
		# __movimentacao do lenhador
		if diferenca <= 2.0:
			pass
		elif $lenhador.position.x > $player.position.x - deslocamento:
			$lenhador.position.x -= velocidade
		
		elif $lenhador.position.x < $player.position.x - deslocamento:
			$lenhador.position.x += velocidade	
		
		#__verificar_dano_sofrido
		if diferenca <= 100 and martelada:
			if not dano_sofrido: # cool down
				get_node("/root/World-07/player").sofreu_dano(10, 1)
				dano_sofrido = true
				cool_down()
		



func _on_timer_timeout():
	contador += 1
	var a = 0
	a = randi() % 2 + 1  # Gera um número inteiro entre 1 e 10
	$lenhador/braco_martelo.play()
	await get_tree().create_timer(0.4).timeout # tempo para o martelo chegar
	martelada = true
	await get_tree().create_timer(0.3).timeout # tempo para cessar dano
	martelada = false
	if contador == 4:
		contador = 0
		if not $urso.vivo: # spawnar urso
			if urso_nasceu:
				vida_inimigo -= 10
				$lenhador/vida_lenhador.value = vida_inimigo
				if vida_inimigo <= 0:
					$lenhador/DanoUrso.visible = true
					await get_tree().create_timer(3).timeout # tempo para cessar dano
					fim_game = true
			
			if not fim_game:	
				$lenhador/mao_jogando_bixo.visible = true
				$lenhador/mao_jogando_bixo.play()
				await get_tree().create_timer(1).timeout
				$lenhador/mao_jogando_bixo.visible = false
				$urso.renascer()
				$urso.position.x = $lenhador.position.x + deslocamento + 360
				urso_nasceu = true

func _on_load_lenhador_body_entered(body):
		if not ativar_lenhador or (ativar_lenhador and not $music_boos.playing):
			$music_boos.play()
		
		ativar_lenhador = true
		$lenhador.visible = true
		$Timer.start()
		
		
