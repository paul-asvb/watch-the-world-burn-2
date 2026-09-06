extends CanvasLayer

@onready var embers_label = $UI/TopBar/EmbersLabel
@onready var stage_label = $UI/TopBar/StageLabel
@onready var stats_label = $UI/TopBar/StatsLabel

func _ready():
	GameManager.embers_changed.connect(_on_embers_changed)
	GameManager.stage_changed.connect(_on_stage_changed)
	GameManager.game_over.connect(_on_game_over)
	update_ui()

func _process(_delta):
	# Update time survived
	GameManager.current_run_stats.time_survived += _delta
	update_stats()

func update_ui():
	update_embers()
	update_stage()
	update_stats()

func update_embers():
	if embers_label:
		embers_label.text = "Embers: %d" % GameManager.current_embers

func update_stage():
	if stage_label:
		var stage = GameManager.get_current_stage()
		stage_label.text = "Stage: %s" % stage.name

func update_stats():
	if stats_label:
		var stats = GameManager.current_run_stats
		stats_label.text = "Burned: %d | Chains: %d | Time: %.1fs" % [
			stats.objects_burned,
			stats.chain_reactions,
			stats.time_survived
		]

func _on_embers_changed(_amount):
	update_embers()

func _on_stage_changed(_new_stage):
	update_stage()
	show_stage_up_notification()

func show_stage_up_notification():
	var label = Label.new()
	label.text = "STAGE UP!"
	label.add_theme_font_size_override("font_size", 64)
	label.add_theme_color_override("font_color", Color(1.0, 0.5, 0.0))
	label.position = Vector2(get_viewport().size.x / 2 - 150, get_viewport().size.y / 2)
	add_child(label)
	
	# Fade out and remove
	var tween = create_tween()
	tween.tween_property(label, "modulate:a", 0.0, 2.0)
	tween.tween_callback(label.queue_free)

func _on_game_over():
	show_game_over_screen()

func show_game_over_screen():
	# Create game over UI
	var panel = Panel.new()
	panel.size = Vector2(800, 600)
	panel.position = Vector2(get_viewport().size.x / 2 - 400, get_viewport().size.y / 2 - 300)
	add_child(panel)
	
	var vbox = VBoxContainer.new()
	vbox.position = Vector2(50, 50)
	vbox.size = Vector2(700, 500)
	panel.add_child(vbox)
	
	# Title
	var title = Label.new()
	title.text = "Run Complete!"
	title.add_theme_font_size_override("font_size", 48)
	title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	vbox.add_child(title)
	
	# Stats
	var stats = GameManager.current_run_stats
	var stats_text = """
Embers Collected: %d
Objects Burned: %d
Trees Burned: %d
Houses Burned: %d
Chain Reactions: %d
Enemies Defeated: %d
Time Survived: %.1f seconds
	""" % [
		stats.embers_collected,
		stats.objects_burned,
		stats.trees_burned,
		stats.houses_burned,
		stats.chain_reactions,
		stats.enemies_defeated,
		stats.time_survived
	]
	
	var stats_label_node = Label.new()
	stats_label_node.text = stats_text
	stats_label_node.add_theme_font_size_override("font_size", 24)
	vbox.add_child(stats_label_node)
	
	# Play Again button
	var button = Button.new()
	button.text = "PLAY AGAIN"
	button.custom_minimum_size = Vector2(200, 60)
	button.pressed.connect(_on_play_again)
	vbox.add_child(button)

func _on_play_again():
	get_tree().reload_current_scene()
	GameManager.start_new_run()
