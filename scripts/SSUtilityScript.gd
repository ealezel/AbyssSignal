extends Node

#Returns True if rate equals a randomly generated number between 0 and rate
static func is_random_true(rate: int) -> bool:
	return (randi() % (rate + 1)) == rate;

static func random_bool() -> bool:
	var rate = 1;
	return (randi() % 1) == rate;

static func random_enum(enum_state):
	return enum_state.keys()[randi() % enum_state.size()];

static func random_int_in_range(min, max) -> int:
	return randi_range(min, max);

static func clean_array(dirty_array: Array) -> Array:
	var cleaned_array = []
	for item in dirty_array:
		if is_instance_valid(item):
			cleaned_array.push_back(item)
	return cleaned_array
	
static func load_json_file(filePath: String):
	if (FileAccess.file_exists(filePath)):
		var dataFile = FileAccess.open(filePath, FileAccess.READ);
		var parsed_result = JSON.parse_string(dataFile.get_as_text());
		
		if (parsed_result is Dictionary):
			return parsed_result
		else:
			print("Error reading file");

static func json_to_class(json_string: String, type: Variant):
	var parsed_object = JSON.parse_string(json_string);
	if(is_instance_of(parsed_object, type)):
		parsed_object
	
	return null;
