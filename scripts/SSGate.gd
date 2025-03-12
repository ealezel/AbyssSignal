extends Node

const SSEnum = preload("res://scripts/enums/SSEnum.gd");

var gate_value: int;
var gate_header: String;
var green_material: Color;
var red_material: Color;
var purple_material: Color;
var is_utility: bool;
var utility: SSEnum.Utility;
var default_anim: Animation;
var power_up_sound: AudioEffect;
var power_down_sound: AudioEffect;

func _ready():
	pass # Replace with function body.
