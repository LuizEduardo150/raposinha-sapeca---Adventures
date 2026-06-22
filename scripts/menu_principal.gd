extends Control


func _ready():
	$raposinha_despreguicando.visible = false
	$raposinha_parada.visible = true
	$raposinha_parada.play()


#func _process(delta):
	#pass
	

func _on_b_comecar_pressed():
	get_tree().change_scene_to_file("res://levels/world_01.tscn")

func _on_b_sair_pressed():
	get_tree().quit()


func _on_timer_timeout():
	$raposinha_despreguicando.visible = true
	$raposinha_parada.visible = false
	$raposinha_despreguicando.play()
	await get_tree().create_timer(2.4).timeout
	$raposinha_despreguicando.visible = false
	$raposinha_parada.visible = true
	
	
