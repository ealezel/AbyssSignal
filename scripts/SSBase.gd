extends Node

@export var is_prodecudal:bool = true;

@export var x_start_padding: int = 0;
@export var final_x_position:int  = 14000;
@export var challenge_free_sets:int = 3;
@export var player_start_location: Vector3i = Vector3i(478,0, 125);
@export var current_transform_location: Vector3i;
@export var current_transform_rotation: Vector3i;
@export var current_transform_scale: Vector3i;
@export var gate_set_min_count:int = 15;
@export var gate_set_max_count:int = 30;
@export var utility_min_count:int = 3;
@export var utility_max_count:int = 6;
@export var challenge_min_count:int = 1;
@export var challenge_max_count:int = 3;
@export var utility_rate:int = 5;
@export var available_gate_count: int = 0;
@export var available_utility_count:int = 5;
@export var available_normal_count:int = 20;
@export var available_challenge_count:int = 3;
@export var challenge_x_padding:int = 1000;
@export var chest_row_min:int = 20;
@export var chest_row_max:int = 30;
@export var chest_column_count:int = 5;
@export var chest_start_location:Vector3i = Vector3i(17000,-260, -18);
@export var chest_x_offset: int = 130;
@export var chest_y_offset: int = 131;
@export var left_gate_location: Vector3 = Vector3(0, -165.5, -50);
@export var right_gate_location: Vector3 = Vector3(0, 165.5, -50);

const SSUtility = preload("res://scripts/SSUtilityScript.gd")
const SSEnum = preload("res://scripts/enums/SSEnum.gd")
const StructClass = preload("res://scripts/SS_StructClass.gd")



const stone_object = preload("res://scenes/ChestScene.tscn")
const deepslate_object = preload("res://scenes/ChestScene.tscn")
const sapphire_object = preload("res://scenes/ChestScene.tscn")
const topaz_object = preload("res://scenes/ChestScene.tscn")
const ruby_object = preload("res://scenes/ChestScene.tscn")
const emerald_object = preload("res://scenes/ChestScene.tscn")
const amethyst_object = preload("res://scenes/ChestScene.tscn")
const onyx_object = preload("res://scenes/ChestScene.tscn")
const diamond_object = preload("res://scenes/ChestScene.tscn")
const empty_object = preload("res://scenes/ChestScene.tscn")

var current_level_name = "Level Zero";

var current_utility_count = 0;
var current_normal_count = 0;
var current_challenge_count = 0;
var current_set_count = 0;
var current_chest_row_count = 0;
var current_chest_location: Vector3i;

var current_x_offset = 0;
var start_x_position = 0;
var available_x_space = 0;
var calculated_x_padding = 0;
var space_available = 0;

var sets:Array[SSEnum.SetType] = [];
var pre_sets:Array[SSEnum.SetType] = [];
var available_utilities:Array[SSEnum.SetType] = [];

var chests:Array[StructClass.StructChest] = [];
var possible_chests:Array[SSEnum.Chest] = [];
var lucky_chests:Array[StructClass.StructChest] = [];
var chest_objects:Array[StructClass.StructChestObject] = [];

var chest_set_data = {};
var current_chest_array_index = 0;

# Called when the node enters the scene tree for the first time.
func _ready():
	randomize_level();
	generate_sets();
	pass # Replace with function body.

func randomize_level():
	available_utilities.clear();
	available_utilities.push_back(SSEnum.Utility.Split);
	available_utilities.push_back(SSEnum.Utility.PowerShot);
	available_utilities.push_back(SSEnum.Utility.Pierce);
	available_utilities.push_back(SSEnum.Utility.Critical);
	
	available_gate_count = SSUtility.random_int_in_range(gate_set_min_count, gate_set_max_count);
	available_utility_count = SSUtility.random_int_in_range(utility_min_count, utility_max_count);
	available_challenge_count = SSUtility.random_int_in_range(challenge_min_count, challenge_max_count);
	
	available_gate_count = available_gate_count - available_utility_count - available_challenge_count;
	start_x_position = player_start_location.x + x_start_padding;
	available_x_space = final_x_position - start_x_position;
	calculated_x_padding = available_x_space / available_gate_count;
	
	generate_pre_sets(challenge_free_sets);
	recalculate_gate_paddings(available_x_space);
	generate_chests();
	pass

func generate_pre_sets(free_challenge_count: int):
	# Randomize Amount of Utilities
	for set_item_index in (free_challenge_count - 1):
		if (available_utility_count > 0):
			if (SSUtility.is_random_true(utility_rate)):
				add_utility(pre_sets);
				current_utility_count = current_utility_count + 1;
			else:
				add_normal(pre_sets);
				current_normal_count = current_normal_count + 1;
				
			
		available_gate_count = available_gate_count - current_utility_count - current_normal_count;
	
	if (available_normal_count > 0):
		for item_index in available_normal_count:
			add_normal(sets);
			current_normal_count = current_normal_count + 1;
		available_normal_count = 0;
	
	if (available_utility_count > 0):
		for utility_index in available_utility_count:
			add_utility(sets);
			current_utility_count = current_utility_count + 1;
		available_utility_count = 0;
	
	if (available_challenge_count > 0):
		for challange_index in available_challenge_count:
			add_challenge(sets);
			current_challenge_count = current_challenge_count
		available_challenge_count = 0;
	
	sets.shuffle();
	
	for current_set in sets:
		pre_sets.push_back(current_set);
	pass

func generate_sets():
	var current_set_index = 0;
	for gate_set in pre_sets:
		if (current_set_index == 0):
			current_x_offset = x_start_padding + player_start_location.x;
			current_transform_location.x = current_x_offset;
		else:
			current_x_offset = current_x_offset + calculated_x_padding;
			
		match gate_set:
			SSEnum.SetType.Normal:
				var spawn_as_left = SSUtility.random_bool();
				#spawn normal gate
				
			SSEnum.SetType.Utility:
				#spawn random utility
				var spawn_as_left = SSUtility.random_bool();
				var selected_utility = SSUtility.random_enum(SSEnum.SetType);
				
			SSEnum.SetType.Challenge:
				#spawn challenge by current_set_index
				var current_gate_set_index = current_set_index;
				
		current_set_index = current_set_index + 1;
	pass

func recalculate_gate_paddings(x_space):
	space_available = x_space;
	for gate_set in pre_sets:
		if (gate_set == SSEnum.SetType.Challenge):
			space_available = space_available - challenge_x_padding;
	calculated_x_padding = space_available / pre_sets.size();
	pass

func generate_chests():
	randomize_chests();
	spawn_chest_set();

func randomize_chests():
	current_chest_row_count = SSUtility.random_int_in_range(chest_row_min, chest_row_max);
	chest_objects.clear();
	
	for chest_row_index in current_chest_row_count:
		for chest_column_index in chest_column_count:
			var chest = get_chest(chest_row_index);
			
			if (chest == null):
				continue
			else:
				var chest_name = SSEnum.Chest.keys()[chest.ChestType];
				print(chest_name);
				var chest_object = prepare_chest_object(chest_row_index, chest_column_index, chest);
				chest_objects.push_back(chest_object);
	pass

func get_chest(row_index: int) -> StructClass.StructChest:
	possible_chests.clear();
	lucky_chests.clear();
	
	var chest_set_data_path = "res://data/ChestSet_Data.json";
	
	chest_set_data = SSUtility.load_json_file(chest_set_data_path);
	current_chest_row_count = chest_set_data.size();
	
	var names = chest_set_data.keys();
	if (row_index > (names.size() - 1)):
		return null;
	
	#var first_row_name = names[0];
	#var last_row_name = names[names.size() - 1];
	#var specific_row_by_name_0 = chest_set_data.get(first_row_name, null);
	#var specific_row_by_name_30 = chest_set_data.get(last_row_name, null);
	
	var selected_chest_set = chest_set_data.get(names[row_index], null);
	#var array_length = selected_chest_set.size();

	for key in selected_chest_set:
		if (selected_chest_set[key] != "Empty" and selected_chest_set[key] != null):
			possible_chests.push_back(SSEnum.Chest.get(selected_chest_set[key]));
	
	var max_chance = 0;
	var main_chest_item: StructClass.StructChest;
	for chest in possible_chests:
		var current_chest_item = get_chest_item(row_index, chest);
		if (current_chest_item == null):
			continue
		if (current_chest_item.ChestType == SSEnum.Chest.Stone):
			if (current_chest_item.Rate == 100):
				max_chance = current_chest_item.Rate;
				main_chest_item = current_chest_item;
		if (current_chest_item.ChestType == SSEnum.Chest.Deepslate):
			if (current_chest_item.Rate == 100):
				max_chance = current_chest_item.Rate;
				main_chest_item = current_chest_item;
		
		for item_index in (current_chest_item.Rate - 1):
			lucky_chests.push_back(current_chest_item);
	
	var current_items_count = lucky_chests.size();
	
	for item in max_chance:
		lucky_chests.push_back(main_chest_item);
		
	lucky_chests.shuffle();
	var result_chest = lucky_chests.pick_random();
	return result_chest

func get_chest_item(row_index: int, chest_type: SSEnum.Chest):
	var chest_file_path = "";
	match chest_type:
		SSEnum.Chest.Stone:
			chest_file_path = "res://data/chests/Stone_Data.json";
		SSEnum.Chest.Deepslate:
			chest_file_path = "res://data/chests/Deepslate_Data.json";
		SSEnum.Chest.Amethyst:
			chest_file_path = "res://data/chests/Amethyst_Data.json";
		SSEnum.Chest.Diamond:
			chest_file_path = "res://data/chests/Diamond_Data.json";
		SSEnum.Chest.Emerald:
			chest_file_path = "res://data/chests/Emerald_Data.json";
		SSEnum.Chest.Onyx:
			chest_file_path = "res://data/chests/Onyx_Data.json";
		SSEnum.Chest.Ruby:
			chest_file_path = "res://data/chests/Ruby_Data.json";
		SSEnum.Chest.Sapphire:
			chest_file_path = "res://data/chests/Sapphire_Data.json";
		SSEnum.Chest.Topaz:
			chest_file_path = "res://data/chests/Topaz_Data.json";
		
		
	var chest_item_data = SSUtility.load_json_file(chest_file_path);
	var names = chest_item_data.keys();
	if (row_index > (names.size() - 1)):
		return null;
	
	var result_chest_data_item = chest_item_data[names[row_index]];
	var result_chest_class_item = StructClass.StructChest.new();
	result_chest_class_item.ChestType = chest_type;
	result_chest_class_item.Name = SSEnum.Chest.keys()[chest_type];
	result_chest_class_item.Life = result_chest_data_item.Life;
	result_chest_class_item.Rate = result_chest_data_item.Rate;
	
	#print("Name: " + result_chest_class_item.Name);
	#print("Life: " + str(result_chest_class_item.Life));
	#print("Rate: " + str(result_chest_class_item.Rate));
	
	return result_chest_class_item;

func prepare_chest_object(row_index: int, column_index:int, chest_struct:StructClass.StructChest) -> StructClass.StructChestObject:

	if (row_index == 0 and column_index == 0):
		current_chest_location = chest_start_location;
	else:
		if (column_index == 0):
			current_chest_location.x = current_chest_location.x + chest_x_offset;
			current_chest_location.y = chest_start_location.y;
		else:
			current_chest_location.y = current_chest_location.y + chest_y_offset;
			
	var result_chest_object = StructClass.StructChestObject.new();
	result_chest_object.ChestType = chest_struct.ChestType;
	result_chest_object.Life = chest_struct.Life;
	result_chest_object.Location = current_chest_location;
	result_chest_object.Rotation = Vector3i(0,0,0);
	result_chest_object.Scale = Vector3i(1, 1, 1);
	
	return result_chest_object;

func spawn_chest_set():
	
	var current_chest_array_last_index = current_chest_array_index + chest_column_count;
	for n in range(current_chest_array_index, current_chest_array_last_index):
		spawn_chest(chest_objects[n]);
		
	current_chest_array_index = current_chest_array_last_index;
	if (current_chest_array_index < (chest_objects.size() - 1)):
		await get_tree().create_timer(0.5).timeout;
		spawn_chest_set();
	pass

func spawn_chest(chest_object: StructClass.StructChestObject):
	match(chest_object.ChestType):
		SSEnum.Chest.Stone:
			chest_object.ChestModel = stone_object;
			pass
		SSEnum.Chest.Deepslate:
			chest_object.ChestModel = deepslate_object;
			pass
		SSEnum.Chest.Sapphire:
			chest_object.ChestModel = sapphire_object;
			pass
		SSEnum.Chest.Topaz:
			chest_object.ChestModel = topaz_object;
			pass
		SSEnum.Chest.Ruby:
			chest_object.ChestModel = ruby_object;
			pass
		SSEnum.Chest.Emerald:
			chest_object.ChestModel = emerald_object;
			pass
		SSEnum.Chest.Amethyst:
			chest_object.ChestModel = amethyst_object;
			pass
		SSEnum.Chest.Onyx:
			chest_object.ChestModel = onyx_object;
			pass
		SSEnum.Chest.Diamond:
			chest_object.ChestModel = diamond_object;
			pass
		SSEnum.Chest.Empty:
			chest_object.ChestModel = emerald_object;
			pass
			
	var chest_instance = chest_object.ChestModel.instantiate();
	chest_instance.position = chest_object.Location;
	add_child(chest_instance);

	pass

func spawn_gate(as_left: bool, is_utility: bool, utility: SSEnum.Utility):
	if (as_left):
		current_transform_location.x = current_x_offset;
		current_transform_location.y = left_gate_location.y;
		current_transform_location.z = left_gate_location.z;
		pass
	else:
		current_transform_location.x = current_x_offset;
		current_transform_location.y = right_gate_location.y;
		current_transform_location.z = right_gate_location.z;
		pass
	
	#spawn SS Gate Object Instance
	

	pass


func add_utility(set_array: Array[SSEnum.SetType]):
	set_array.push_back(SSEnum.SetType.Utility);
	pass

func add_normal(set_array: Array[SSEnum.SetType]):
	set_array.push_back(SSEnum.SetType.Normal);
	pass

func add_challenge(set_array: Array[SSEnum.SetType]):
	set_array.push_back(SSEnum.SetType.Challenge);
	pass

