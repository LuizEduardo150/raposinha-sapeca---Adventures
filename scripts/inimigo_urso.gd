extends CharacterBody2D



const SPEED = 900.0
const JUMP_VELOCITY = -400.0
var direction := -1

@onready var wall_detector := $wall_detector as RayCast2D
# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var vivo = true
var voz_tocando = false
var init = true

func renascer():
	init = true
	vivo = true
	set_andando()

func _ready():
	vivo = false
	set_andando()
	$andando.visible = false


func _process(delta):
	if not vivo and not voz_tocando:
		voz_tocando = true
		if not init:
			raposa_sound()
		else:
			init = false
		await get_tree().create_timer(2).timeout

func raposa_sound():
	var random_number = randi() % 3 + 1
	if random_number == 1:
		$rapos_toma.play()
	elif random_number == 2:
		$rapos_vc_vai_ver.play()
	elif random_number == 3:	
		$da_na_cara.play()
		
func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta
		
	if wall_detector.is_colliding():
		direction *= -1
		wall_detector.scale.x *= -1
		
	if direction == 1:
		if $andando.scale.x > 0:
			$andando.scale.x *= -1
		if $ataque.scale.x > 0:
			$ataque.scale.x *= -1
		if $morte.scale.x > 0:
			$morte.scale.x *= -1
	else:
		if $andando.scale.x < 0:
			$andando.scale.x *= -1
		if $ataque.scale.x < 0:
			$ataque.scale.x *= -1
		if $morte.scale.x < 0:
			$morte.scale.x *= -1
		
	velocity.x = direction * SPEED * delta * 10

	move_and_slide()

func _on_ponto_fraco_body_entered(body):
	if body.name == 'player' and vivo:
		vivo = false
		move_and_slide()
		set_morrendo()
		await get_tree().create_timer(0.3).timeout
		$morte.visible = false


func _on_ataque_area_body_entered(body):
		if  vivo and body.name == 'player':
			get_parent().get_node("player").sofreu_dano(20, 1)
			set_atack()
			await get_tree().create_timer(0.3).timeout
			set_andando()

func set_atack():
	$andando.visible = false
	$ataque.visible = true
	$morte.visible = false
	$ataque.play()
	
func set_andando():
	$andando.visible = true
	$ataque.visible = false
	$morte.visible = false
	
func set_morrendo():
	$andando.visible = false
	$ataque.visible = false
	$morte.visible = true
	$morte.play()
