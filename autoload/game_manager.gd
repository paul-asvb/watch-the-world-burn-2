extends Node

# Game state
var current_run_stats = {
	"embers_collected": 0,
	"objects_burned": 0,
	"trees_burned": 0,
	"houses_burned": 0,
	"enemies_defeated": 0,
	"chain_reactions": 0,
	"longest_chain": 0,
	"percent_burned": 0.0,
	"time_survived": 0.0
}

# Meta progression
var total_embers = 0
var unlocked_flames = []
var permanent_upgrades = {}

# Current run
var current_embers = 0
var flame_stage = 0
var current_upgrades = []

# Flame stages
const STAGES = [
	{"name": "Spark", "embers_needed": 0, "speed_mult": 2.0, "size": 0.5},
	{"name": "Flame", "embers_needed": 100, "speed_mult": 1.5, "size": 1.0},
	{"name": "Blaze", "embers_needed": 300, "speed_mult": 1.2, "size": 1.5},
	{"name": "Inferno", "embers_needed": 600, "speed_mult": 0.9, "size": 2.5},
	{"name": "Wildfire", "embers_needed": 1000, "speed_mult": 0.6, "size": 4.0},
	{"name": "Cataclysm", "embers_needed": 1500, "speed_mult": 0.4, "size": 6.0}
]

signal embers_changed(amount)
signal stage_changed(new_stage)
signal upgrade_available
signal game_over

func _ready():
	load_meta_progression()

func start_new_run():
	current_run_stats = {
		"embers_collected": 0,
		"objects_burned": 0,
		"trees_burned": 0,
		"houses_burned": 0,
		"enemies_defeated": 0,
		"chain_reactions": 0,
		"longest_chain": 0,
		"percent_burned": 0.0,
		"time_survived": 0.0
	}
	current_embers = 0
	flame_stage = 0
	current_upgrades = []

func add_embers(amount: int):
	current_embers += amount
	current_run_stats.embers_collected += amount
	embers_changed.emit(current_embers)
	
	# Check for stage up
	check_stage_upgrade()

func check_stage_upgrade():
	if flame_stage < STAGES.size() - 1:
		var next_stage = flame_stage + 1
		if current_embers >= STAGES[next_stage].embers_needed:
			flame_stage = next_stage
			stage_changed.emit(flame_stage)
			upgrade_available.emit()

func get_current_stage():
	return STAGES[flame_stage]

func get_speed_multiplier():
	return STAGES[flame_stage].speed_mult

func get_size_multiplier():
	return STAGES[flame_stage].size

func end_run():
	total_embers += current_run_stats.embers_collected
	save_meta_progression()
	game_over.emit()

func save_meta_progression():
	var save_data = {
		"total_embers": total_embers,
		"unlocked_flames": unlocked_flames,
		"permanent_upgrades": permanent_upgrades
	}
	var file = FileAccess.open("user://save_data.json", FileAccess.WRITE)
	if file:
		file.store_string(JSON.stringify(save_data))
		file.close()

func load_meta_progression():
	if FileAccess.file_exists("user://save_data.json"):
		var file = FileAccess.open("user://save_data.json", FileAccess.READ)
		if file:
			var json = JSON.new()
			var parse_result = json.parse(file.get_as_text())
			if parse_result == OK:
				var data = json.data
				total_embers = data.get("total_embers", 0)
				unlocked_flames = data.get("unlocked_flames", [])
				permanent_upgrades = data.get("permanent_upgrades", {})
			file.close()
