extends Area2D


@onready var transition = $"../transition"
@export var next_level : String = ""
var level = 0


func _ready():
	var current_scene = get_tree().current_scene
	
	if "World-01" in str(current_scene):
		$pizza.visible = false
		$bala_matinho.visible = false
		$disco.visible = false
		$cogumelo.visible = false
		$refreferante_s_gas.visible = false
		$taco.visible = true
		$espinafre.visible = false
		level = 1
		$segunda.play()
		
	
	elif "World-02" in str(current_scene):
		$pizza.visible = false
		$bala_matinho.visible = false
		$disco.visible = false
		$cogumelo.visible = false
		$refreferante_s_gas.visible = true
		$taco.visible = false
		$espinafre.visible = false
		level = 2
		$terca.play()
		
	elif "World-03" in str(current_scene):
		$pizza.visible = false
		$bala_matinho.visible = false
		$disco.visible = false
		$cogumelo.visible = false
		$refreferante_s_gas.visible = false
		$taco.visible = false
		$espinafre.visible = true
		level = 3
		$quarta.play()
		
	elif "World-04" in str(current_scene):
		$pizza.visible = false
		$bala_matinho.visible = false
		$disco.visible = false
		$cogumelo.visible = true
		$refreferante_s_gas.visible = false
		$taco.visible = false
		$espinafre.visible = false
		level = 4
		$quinta.play()
		
	elif "World-05" in str(current_scene):
		$pizza.visible = false
		$bala_matinho.visible = false
		$disco.visible = true
		$cogumelo.visible = false
		$refreferante_s_gas.visible = false
		$taco.visible = false
		$espinafre.visible = false
		level = 5
		$sexta.play()
		
	elif "World-06" in str(current_scene):
		$music_init.stop()
		$music_sabado.play()
		$pizza.visible = false
		$bala_matinho.visible = true
		$disco.visible = false
		$cogumelo.visible = false
		$refreferante_s_gas.visible = false
		$taco.visible = false
		$espinafre.visible = false
		level = 6
		$sabado.play()
		
		
	elif "World-07" in str(current_scene):
		$music_init.stop()
		$pizza.visible = true
		$bala_matinho.visible = false
		$disco.visible = false
		$cogumelo.visible = false
		$refreferante_s_gas.visible = false
		$taco.visible = false
		$espinafre.visible = false
		level = 7
		$domingo.play()
		
		
func _on_body_entered(body):
	if body.name == "player" and !next_level == "":
		
		if level == 1:
			$hmmtaco.play()
			await get_tree().create_timer(2).timeout
		elif level == 2:
			$refri_s_gas.play()
			await get_tree().create_timer(2).timeout
		elif level == 3:
			$hmmespinafre.play()
			await get_tree().create_timer(2).timeout
		elif level == 4:
			$hmm_cogumelo.play()
			await get_tree().create_timer(2).timeout
		elif level == 5:
			$hmm_musiquinha.play()
			await get_tree().create_timer(2).timeout
		elif level == 6:
			$hmm_balinha.play()
			await get_tree().create_timer(2).timeout
		elif level == 7:
			$hmm_pizza.play()
			await get_tree().create_timer(2).timeout
		
		transition.change_scene(next_level)
	else:
		print("No Scene Loaded")
