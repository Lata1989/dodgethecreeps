extends Node

#const MOB = preload("res://scenes/mob.tscn")
@export var mob_scene: PackedScene = preload("res://scenes/mob.tscn")
#@export var mob_scene: PackedScene
var score: int

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#pass # Replace with function body.
	new_game()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func game_over() -> void:
	#pass # Replace with function body.
	$ScoreTimer.stop()
	$MobTimer.stop()
	$HUD.show_game_over()
	$Music.stop()
	$DeathSound.play()

func new_game():
	get_tree().call_group("mobs", "queue_free")
	score = 0
	$Player.start($StartPosition.position)
	$StartTimer.start()
	$HUD.update_score(score)
	$HUD.show_message("Preparate!!")
	$Music.play()


func _on_start_timer_timeout() -> void:
	#pass # Replace with function body.
	$MobTimer.start()
	$ScoreTimer.start()


func _on_score_timer_timeout() -> void:
	#pass # Replace with function body.
	score += 1
	$HUD.update_score(score)


func _on_mob_timer_timeout() -> void:
	#pass # Replace with function body.
	# Crear una nueva instancia de Mob Scene
	var mob = mob_scene.instantiate()
	
	# Elegir una ubicacion aleatoria en Path2D (MobPath)
	var mob_spawn_location = $MobPath/MobSpawnLocation
	mob_spawn_location.progress_ratio = randf()
	
	# Setear la direccion del mob perpendicular a la direccion
	var direction = mob_spawn_location.rotation + PI / 2
	
	# Setear la posicion del mob en un lugar random
	mob.position = mob_spawn_location.position
	
	# Agregar algo de aleatoriedad a la direccion
	direction += randf_range(-PI / 4, PI / 4)
	mob.rotation = direction
	
	# Elegir la velocidad del mob
	var velocity =  Vector2(randf_range(150.0, 250.0), 0.0)
	mob.linear_velocity = velocity.rotated(direction)
	
	# Spawnear el mob agregandolo a la escena principal
	add_child(mob)
