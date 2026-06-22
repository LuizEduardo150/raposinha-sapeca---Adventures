extends CharacterBody2D


const SPEED = 900.0
const JUMP_VELOCITY = -400.0
var direction := -1

@onready var wall_detector := $wall_detector as RayCast2D
@onready var texture := $texture as Sprite2D
# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var vivo = true
var voz_tocando = false

func _process(delta):
	if not vivo and not voz_tocando:
		voz_tocando = true
		raposa_sound()
		await get_tree().create_timer(2).timeout
		queue_free()

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
		texture.flip_h = true
	else:
		texture.flip_h = false
	velocity.x = direction * SPEED * delta

	move_and_slide()

func _on_ponto_fraco_body_entered(body):
	if body.name == 'player':
		vivo = false
		move_and_slide()
		$anim.play("hurt")
		await get_tree().create_timer(0.3).timeout
		$texture.visible = false

func _on_area_2d_body_entered(body):
	if  vivo and body.name == 'player':
		get_parent().get_node("player").sofreu_dano(10, direction)
		$anim.play("chomp")
		$anim.speed_scale = 4
		await get_tree().create_timer(0.3).timeout
		$anim.speed_scale = 1
		$anim.play("crawl")

		
