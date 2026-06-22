extends CharacterBody2D

# Velocidade de movimentação
var speed = 20.0
# Raio do movimento circular
var radius = 5.0
# Ângulo inicial
var angle = 0.0
# Tempo para mudar o movimento (em segundos)
var change_time = 2.0
var time_elapsed = 0.0
var vivo = true

# Referência ao Node de animação
@onready var animation_player = $anim_mosca
@onready var area2d = $Area2D  # Assumindo que há um Area2D para detecção de colisão

func _ready():
	# Inicia a animação
	animation_player.play("fly")

func _process(delta):
	# Atualiza o tempo
	time_elapsed += delta
	
	# Move a mosca em círculo
	var circle_x = radius * cos(angle)
	var circle_y = radius * sin(angle)
	
	position += Vector2(circle_x, circle_y) * speed * delta
	
	# Atualiza o ângulo
	angle += 2.0 * PI * delta
	
	# Verifica se é hora de mudar o movimento
	if time_elapsed >= change_time:
		change_movement()
		time_elapsed = 0.0

func change_movement():
	# Muda o movimento para aleatório
	var new_radius = randf_range(5.0, 20.0)
	var new_speed = randf_range(10.0, 30.0)
	
	radius = new_radius
	speed = new_speed

func _on_area_2d_body_entered(body):
	if vivo and body.name == 'player':
		# O jogador sofre dano ao colidir com a mosca
		#get_parent().get_node("player").sofreu_dano(10, sign(body.position.x - position.x), 'mosca')
		animation_player.play("attack")  # Supondo que há uma animação de ataque
		animation_player.speed_scale = 4
		await get_tree().create_timer(0.3).timeout
		animation_player.speed_scale = 1
		animation_player.play("fly")  # Volta à animação de voo
