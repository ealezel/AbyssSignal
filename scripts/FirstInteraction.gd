extends Node
#Interface:
#is_valid(game_data)
#execute(game_data)

var execution_limit = 1

func is_valid(_game_data):
	#check execution condition
	return true

func execute(game_data):
	game_data.first_interaction_executed_count = game_data.first_interaction_executed_count + 1
	print_debug("Interaction Detected! Current Interecation Count: ", game_data.first_interaction_executed_count)
