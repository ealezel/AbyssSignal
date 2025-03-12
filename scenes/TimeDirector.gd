extends Node

@onready var world_environment = $"../WorldEnvironment"

const MINUTES_PER_DAY = 1440
const MINUTES_PER_HOUR = 60
const INGAME_TO_REAL_MINUTE_DURATION = (2 * PI) / MINUTES_PER_DAY

signal time_tick(day:int, hour:int, minute:int)

#@export var gradient_texture:GradientTexture1D
@export var INGAME_SPEED = 20.0
@export var INITIAL_HOUR = 12:
	set(h):
		INITIAL_HOUR = h
		time = INGAME_TO_REAL_MINUTE_DURATION * MINUTES_PER_HOUR * INITIAL_HOUR

var time:float= 0.0
var past_minute:int= -1

# Called when the node enters the scene tree for the first time.
func _ready():
	time = INGAME_TO_REAL_MINUTE_DURATION * MINUTES_PER_HOUR * INITIAL_HOUR

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	time += delta * INGAME_TO_REAL_MINUTE_DURATION * INGAME_SPEED
	
	var value = (sin(time - PI / 2.0) + 1.0) / 2.0
	
	day_cycle(value)
	
	_recalculate_time()	

func _recalculate_time():
	var total_minutes = int(time / INGAME_TO_REAL_MINUTE_DURATION)
	
	var day : int = int(total_minutes / MINUTES_PER_DAY)

	var current_day_minutes = total_minutes % MINUTES_PER_DAY

	var hour : int = int(current_day_minutes / MINUTES_PER_HOUR)
	var minute : int = int(current_day_minutes % MINUTES_PER_HOUR)
	
	if past_minute != minute:
		past_minute = minute
		time_tick.emit(day, hour, minute)


func day_cycle(value: float):
	world_environment.environment.volumetric_fog_albedo = Color("WHITE") * value
	world_environment.environment.background_energy_multiplier = 1.0 * value
