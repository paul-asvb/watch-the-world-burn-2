extends CharacterBody2D

@export var base_speed = 300.0
@export var burn_radius = 50.0

var current_size = 1.0
var touch_input_active = false
var touch_target = Vector2.ZERO

func _ready():
	GameManager.stage_changed.connect(_on_stage_changed)
	update_flame_properties()

func _physics_process(delta):
	var input_vector = Vector2.ZERO
	
	# Keyboard/gamepad input
	input_vector.x = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	input_vector.y = Input.get_action_strength("move_down") - Input.get_action_strength("move_up")
	
	# Touch input
	if touch_input_active:
		var direction = (touch_target - global_position).normalized()
		if global_position.distance_to(touch_target) > 10:
			input_vector = direction
		else:
			touch_input_active = false
	
	input_vector = input_vector.normalized()
	
	# Apply speed based on current stage
	var speed = base_speed * GameManager.get_speed_multiplier()
	velocity = input_vector * speed
	
	move_and_slide()
	
	# Burn nearby objects
	burn_nearby_objects()

func _input(event):
	# Mobile touch controls
	if event is InputEventScreenTouch:
		if event.pressed:
			touch_input_active = true
			touch_target = event.position
	elif event is InputEventScreenDrag:
		touch_target = event.position

func burn_nearby_objects():
	# Get all burnable objects in range
	var space_state = get_world_2d().direct_space_state
	var query = PhysicsShapeQueryParameters2D.new()
	var shape = CircleShape2D.new()
	shape.radius = burn_radius * current_size
	query.shape = shape
	query.transform = global_transform
	query.collision_mask = 2  # Burnable layer
	
	var results = space_state.intersect_shape(query)
	for result in results:
		var collider = result.collider
		if collider.has_method("burn"):
			collider.burn()

func _on_stage_changed(new_stage):
	update_flame_properties()

func update_flame_properties():
	current_size = GameManager.get_size_multiplier()
	scale = Vector2.ONE * current_size
	
func take_damage():
	# Water hit - game over
	GameManager.end_run()
	queue_free()
