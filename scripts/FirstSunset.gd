extends Node
#Interface:
#is_valid(game_data)
#execute(game_data)

var execution_limit = 1

func is_valid(game_data):
	#check execution condition
	if (game_data.first_sunset_executed_count < execution_limit 
	and game_data.day == 0 
	and game_data.time > 21):
		return true
	else:
		return false

func execute(game_data):
	game_data.first_sunset_executed_count = game_data.first_sunset_executed_count + 1
	print_debug("Enjoying first Sunset!")
