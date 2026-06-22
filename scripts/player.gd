extends CharacterBody2D

const SPEED = 300.0
const JUMP_FORCE = -400.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var direcao_atual = 'r'
var direcao_atualizada = false
var life = 100

# interfasse gráfica
var life_bar_value : ProgressBar
var dano_sofrido = false
var direcao_dano : int = 0
var pulando = false
var tomando_dano = false
var inimigo_bateu = ''

func som_dano():
	var random_number = randi() % 2 + 1
	print(random_number)
	if random_number == 1:
		$misericordia.play()
	elif random_number == 2:
		$meu_deus.play()
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if life <= 0:
		get_tree().change_scene_to_file("res://levels/menu_morreu.tscn")
	

func _ready():
	# pegando referência dos itens
	life_bar_value = get_node("../GUI_itens/life/ProgressBar_life")
	
	set_raposinha_parada(1)
	$andando_4.play()
	$parada_4.play()
	$pulo_4.visible = false
	$dano_recebido.visible = false
	

func sofreu_dano(dano:int, direction:int, causador:String = 'inimigo1'):
	inimigo_bateu = causador
	som_dano()
	life -= dano
	life_bar_value.value = life
	dano_sofrido = true
	direcao_dano = direction
	$andando_4.visible = false
	$parada_4.visible = false
	$pulo_4.visible = false
	$dano_recebido.visible = true
	tomando_dano = true
	
	if direcao_atual == 'r' and $dano_recebido.scale.x > 0:
		$dano_recebido.scale.x *= -1
	elif direcao_atual == 'l' and $dano_recebido.scale.x < 0:
		$dano_recebido.scale.x *= -1
	$dano_recebido.play()
	await get_tree().create_timer(0.2).timeout
	#$parada_4.visible = false
	$dano_recebido.visible = false
	tomando_dano = false
		
	
func set_raposinha_andando(direction:int):
	if not tomando_dano:
		$parada_4.visible = false
		$andando_4.visible = true
		if direction >= 1 and $andando_4.scale.x > 0:
			$andando_4.scale.x *= -1 # girar personagem
			direcao_atual = 'r'
			direcao_atualizada = false
		elif direction <= 0 and $andando_4.scale.x < 0:
			$andando_4.scale.x *= -1 # girar personagem
			direcao_atual = 'l'
			direcao_atualizada = false
		
func set_raposinha_parada(direction:int):
	if not tomando_dano:
		$parada_4.visible = true
		$andando_4.visible = false
		
		if not direcao_atualizada and direcao_atual == 'r': # direita
			if $parada_4.scale.x > 0:
				$parada_4.scale.x *= -1 # girar personagem
			direcao_atualizada = true
			
		elif not direcao_atualizada and direcao_atual == 'l': # esquerda
			if $parada_4.scale.x < 0:
				$parada_4.scale.x *= -1 # girar personagem
			direcao_atualizada = true

func set_raposinha_pulando(direction:int):
	pulando = true
	$parada_4.visible = false
	$andando_4.visible = false
	$pulo_4.visible = true
	$pulo_4.play()
	if direcao_atual == 'l' and $pulo_4.scale.x < 0:
		$pulo_4.scale.x *= -1
	elif direcao_atual == 'r' and $pulo_4.scale.x > 0:
			$pulo_4.scale.x *= -1
	
	await get_tree().create_timer(0.7).timeout
	pulando = false
	$pulo_4.visible = false
	$parada_4.visible = true


func _physics_process(delta):
	
	if position.y > 1000:
		sofreu_dano(100, 0)
	
	var direction = Input.get_axis("ui_left", "ui_right")
	
	if not is_on_floor(): # caindo/voando
		velocity.y += gravity * delta
	
	
	if Input.is_action_just_pressed("ui_accept") and is_on_floor(): # Pulo
		velocity.y = JUMP_FORCE
		set_raposinha_pulando(direction)
		
	elif not dano_sofrido:
		velocity.x = direction * SPEED
		if direction != 0 and not pulando: # andando e com os pés no chão
			set_raposinha_andando(direction)
		else: # parada
			if not pulando:
				set_raposinha_parada(direction)
	
	elif dano_sofrido:
		var potencia = 0
		if inimigo_bateu == 'inimigo1':
			potencia = 5
		elif inimigo_bateu == "mosca":
			potencia = 15
		else:
			potencia = 5
		
		if $parada_4.visible == true: # raposinha parada
			if direcao_atual == 'r' and direcao_dano > 0:
				velocity.x = potencia * SPEED
			elif direcao_atual == 'r' and direcao_dano < 0:
				velocity.x = -potencia * SPEED
			elif direcao_atual == 'l' and direcao_dano > 0:
				velocity.x = potencia * SPEED
			elif direcao_atual == 'l' and direcao_dano < 0:
				velocity.x = -potencia * SPEED
		else: # andando
			if direcao_atual == 'r' and direcao_dano > 0:
				velocity.x = -potencia * SPEED
			elif direcao_atual == 'r' and direcao_dano < 0:
				velocity.x = -potencia * SPEED
			elif direcao_atual == 'l' and direcao_dano > 0:
				velocity.x = potencia * SPEED
			elif direcao_atual == 'l' and direcao_dano < 0:
				velocity.x = potencia * SPEED
		
		dano_sofrido = false
	
	'''else: # parece que está inutilizavel
		# parada
		velocity.x = move_toward(velocity.x, 0, SPEED)'''

	move_and_slide()
