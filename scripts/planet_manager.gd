extends Node2D

@export var planet_radius = 2000.0
@export var view_radius = 1200.0

var player: CharacterBody2D
var camera: Camera2D

func _ready():
	# Find or create player
	player = get_node_or_null("Player")
	if not player:
		player = preload("res://scenes/player.tscn").instantiate()
		add_child(player)
	
	# Setup camera
	camera = Camera2D.new()
	player.add_child(camera)
	camera.enabled = true
	camera.zoom = Vector2(0.8, 0.8)

func _process(_delta):
	if player:
		wrap_player_position()

func wrap_player_position():
	# Calculate distance from center
	var pos = player.global_position
	var distance = pos.length()
	
	# If player goes too far from center, wrap them around
	if distance > planet_radius:
		# Wrap to opposite side
		player.global_position = -pos.normalized() * (planet_radius - 100)

func generate_planet_objects(biome_type = "mixed"):
	# Generate burnable objects based on biome
	var objects_to_spawn = []
	
	match biome_type:
		"forest":
			objects_to_spawn = [
				{"type": "tree", "count": 100},
				{"type": "grass", "count": 200},
				{"type": "house", "count": 20}
			]
		"mushroom":
			objects_to_spawn = [
				{"type": "mushroom", "count": 80},
				{"type": "grass", "count": 150}
			]
		_:
			objects_to_spawn = [
				{"type": "grass", "count": 150},
				{"type": "tree", "count": 60},
				{"type": "house", "count": 15},
				{"type": "mushroom", "count": 30}
			]
	
	# Spawn objects randomly around the planet
	for obj_data in objects_to_spawn:
		for i in range(obj_data.count):
			spawn_object(obj_data.type)

func spawn_object(type: String):
	# Random position within planet radius
	var angle = randf() * TAU
	var distance = randf() * planet_radius * 0.8
	var pos = Vector2(cos(angle), sin(angle)) * distance
	
	var obj = create_object_by_type(type)
	obj.position = pos
	add_child(obj)

func create_object_by_type(type: String) -> BurnableObject:
	var obj = preload("res://scenes/burnable_object.tscn").instantiate()
	
	match type:
		"grass":
			obj.ember_value = 5
			obj.burn_time = 0.3
			obj.spread_chance = 0.8
			obj.spread_radius = 80
			obj.object_type = "grass"
			# Make it look like grass (green rectangle)
			var shape = RectangleShape2D.new()
			shape.size = Vector2(20, 20)
			obj.get_node("CollisionShape2D").shape = shape
			obj.modulate = Color(0.2, 0.8, 0.2)
			
		"tree":
			obj.ember_value = 50
			obj.burn_time = 2.0
			obj.spread_chance = 0.5
			obj.spread_radius = 150
			obj.object_type = "tree"
			# Make it look like a tree (brown + green)
			var shape = CircleShape2D.new()
			shape.radius = 40
			obj.get_node("CollisionShape2D").shape = shape
			obj.modulate = Color(0.4, 0.6, 0.2)
			obj.scale = Vector2(1.5, 2.0)
			
		"house":
			obj.ember_value = 200
			obj.burn_time = 3.0
			obj.spread_chance = 0.4
			obj.spread_radius = 200
			obj.object_type = "house"
			# Make it look like a house (square)
			var shape = RectangleShape2D.new()
			shape.size = Vector2(60, 60)
			obj.get_node("CollisionShape2D").shape = shape
			obj.modulate = Color(0.7, 0.5, 0.3)
			
		"mushroom":
			obj.ember_value = 30
			obj.burn_time = 1.0
			obj.spread_chance = 0.9
			obj.spread_radius = 250
			obj.object_type = "mushroom"
			# Make it look like a mushroom (circle)
			var shape = CircleShape2D.new()
			shape.radius = 30
			obj.get_node("CollisionShape2D").shape = shape
			obj.modulate = Color(0.8, 0.3, 0.8)
	
	return obj
