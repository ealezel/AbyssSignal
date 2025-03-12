extends Node

@onready var game_data = $GameData

@onready var greatings = $Greatings
@onready var first_sunset = $FirstSunset
@onready var first_interaction = $FirstInteraction

@onready var time_director = $"../TimeDirector"
@onready var wall_clock = $"../Enviroment/Ship/WallClock"


var save_path = "user://abyss_data.save"

# Called when the node enters the scene tree for the first time.
func _ready():
	load_game()
	
	time_director.time_tick.connect(wall_clock.set_daytime)
	
	if attempt_to_trigger(greatings):
		print_debug("Script 'Greatings' executed successfully: ", game_data.greatings_executed_count)
	

func attempt_to_trigger(script):
	if script.has_method('is_valid'):
		if script.is_valid(game_data):
				script.execute(game_data)
				return true
	return false


func _on_first_area_3d_body_entered(body):
	if body.is_in_group("player"):
		attempt_to_trigger(first_interaction)

func save_game():
	var file = FileAccess.open(save_path, FileAccess.WRITE)
	file.store_var(game_data.day)
	file.store_var(game_data.time)
	file.store_var(game_data.insanity)
	file.store_var(game_data.health)
	file.store_var(game_data.energy)
	file.store_var(game_data.progress)
	file.store_var(game_data.greatings_executed_count)
	file.store_var(game_data.first_sunset_executed_count)
	file.store_var(game_data.first_interaction_executed_count)


func load_game():
	if FileAccess.file_exists(save_path):
		var file = FileAccess.open(save_path, FileAccess.READ)
		game_data.day = file.get_var(game_data.day)
		game_data.time = file.get_var(game_data.time)
		game_data.insanity = file.get_var(game_data.insanity)
		game_data.health = file.get_var(game_data.health)
		game_data.energy = file.get_var(game_data.energy)
		game_data.progress = file.get_var(game_data.progress)
		game_data.greatings_executed_count = file.get_var(game_data.greatings_executed_count)
		game_data.first_sunset_executed_count = file.get_var(game_data.first_sunset_executed_count)
		game_data.first_interaction_executed_count = file.get_var(game_data.first_interaction_executed_count)
	else:
		game_data.day = 0
		game_data.time = 0
		game_data.insanity = 100
		game_data.health = 100
		game_data.energy = 100
		game_data.progress = 0
		game_data.greatings_executed_count = 0;
		game_data.first_sunset_executed_count = 0;
		game_data.first_interaction_executed_count = 0;
