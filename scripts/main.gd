extends Node2D

func _ready():
	GameManager.start_new_run()
	
	# Get planet manager and generate initial planet
	var planet_manager = $PlanetManager
	if planet_manager:
		planet_manager.generate_planet_objects("mixed")
		
		# Spawn some enemies
		spawn_enemies(planet_manager, 5)

func spawn_enemies(planet_manager, count):
	var enemy_scene = preload("res://scenes/enemy.tscn")
	
	for i in range(count):
		var enemy = enemy_scene.instantiate()
		
		# Random position around planet
		var angle = randf() * TAU
		var distance = randf() * planet_manager.planet_radius * 0.7
		enemy.position = Vector2(cos(angle), sin(angle)) * distance
		
		planet_manager.add_child(enemy)
