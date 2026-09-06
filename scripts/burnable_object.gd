extends StaticBody2D
class_name BurnableObject

@export var ember_value = 10
@export var burn_time = 1.0
@export var spread_chance = 0.3
@export var spread_radius = 100.0
@export var object_type = "grass"  # grass, tree, house, etc.

var is_burning = false
var is_burned = false
var burn_progress = 0.0

signal burned(object_type)
signal chain_reaction(from_object)

func _ready():
	add_to_group("burnable")
	collision_layer = 2

func _process(delta):
	if is_burning and not is_burned:
		burn_progress += delta / burn_time
		
		# Visual feedback - modulate color
		modulate = Color(1.0, 1.0 - burn_progress, 1.0 - burn_progress)
		
		if burn_progress >= 1.0:
			complete_burn()

func burn():
	if is_burning or is_burned:
		return
	
	is_burning = true
	# Play fire particle effect
	create_fire_particles()

func complete_burn():
	is_burned = true
	is_burning = false
	
	# Award embers
	GameManager.add_embers(ember_value)
	GameManager.current_run_stats.objects_burned += 1
	
	# Track specific object types
	match object_type:
		"tree":
			GameManager.current_run_stats.trees_burned += 1
		"house":
			GameManager.current_run_stats.houses_burned += 1
	
	burned.emit(object_type)
	
	# Try to spread fire
	spread_fire()
	
	# Change appearance to burned
	modulate = Color(0.2, 0.2, 0.2)

func spread_fire():
	if randf() > spread_chance:
		return
	
	# Find nearby burnable objects
	var space_state = get_world_2d().direct_space_state
	var query = PhysicsShapeQueryParameters2D.new()
	var shape = CircleShape2D.new()
	shape.radius = spread_radius
	query.shape = shape
	query.transform = global_transform
	query.collision_mask = 2
	
	var results = space_state.intersect_shape(query)
	var chain_started = false
	
	for result in results:
		var collider = result.collider
		if collider != self and collider.has_method("burn"):
			if not collider.is_burning and not collider.is_burned:
				collider.burn()
				if not chain_started:
					GameManager.current_run_stats.chain_reactions += 1
					chain_reaction.emit(self)
					chain_started = true

func create_fire_particles():
	# Create simple fire particle effect
	var particles = GPUParticles2D.new()
	add_child(particles)
	particles.amount = 20
	particles.lifetime = 0.5
	particles.emitting = true
	particles.modulate = Color(1.0, 0.5, 0.0)
	
	# Create a simple particle material
	var material = ParticleProcessMaterial.new()
	material.direction = Vector3(0, -1, 0)
	material.spread = 45
	material.initial_velocity_min = 50.0
	material.initial_velocity_max = 100.0
	material.gravity = Vector3(0, -50, 0)
	particles.process_material = material
	particles.one_shot = false
