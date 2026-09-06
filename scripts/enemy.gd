extends CharacterBody2D
class_name Enemy

@export var speed = 150.0
@export var enemy_type = "rain_sprite"
@export var ember_drop = 25

var player: Node2D
var active = true

func _ready():
	add_to_group("enemies")
	collision_layer = 4
	collision_mask = 1

func _physics_process(delta):
	if not active:
		return
	
	# Find player
	if not player:
		player = get_tree().get_first_node_in_group("player")
		return
	
	# Move towards player
	var direction = (player.global_position - global_position).normalized()
	velocity = direction * speed
	move_and_slide()
	
	# Check if touching player
	for i in get_slide_collision_count():
		var collision = get_slide_collision(i)
		if collision.get_collider().is_in_group("player"):
			hit_player(collision.get_collider())

func hit_player(player_node):
	# Player dies from water
	if player_node.has_method("take_damage"):
		player_node.take_damage()

func defeat():
	# Enemy defeated by fire
	GameManager.add_embers(ember_drop)
	GameManager.current_run_stats.enemies_defeated += 1
	
	# Create particle effect
	create_death_particles()
	
	queue_free()

func create_death_particles():
	var particles = GPUParticles2D.new()
	get_parent().add_child(particles)
	particles.global_position = global_position
	particles.amount = 30
	particles.lifetime = 1.0
	particles.emitting = true
	particles.one_shot = true
	
	# Auto-delete after particles finish
	await get_tree().create_timer(2.0).timeout
	particles.queue_free()
