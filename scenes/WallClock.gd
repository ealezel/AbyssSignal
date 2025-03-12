extends Node3D

@export var mesh_hours_path: NodePath
@onready var mesh_hours = get_node(mesh_hours_path)

@export var mesh_minutes_path: NodePath
@onready var mesh_minutes = get_node(mesh_minutes_path)

@export var mesh_seconds_path: NodePath
#@onready var mesh_seconds = get_node(mesh_seconds_path)

var radian_seconds = null
var radian_minutes = null
var radian_hours = null

# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	#radian_seconds = Time.get_time_dict_from_system()["second"] * (PI/30)
	#radian_minutes = Time.get_time_dict_from_system()["minute"] * (PI/30) + radian_seconds / 60
	#radian_hours = Time.get_time_dict_from_system()["hour"] * (PI/6) + radian_minutes / 12
	#
	#mesh_hours.rotate_x(-radian_hours)
	#mesh_minutes.rotate_x(-radian_minutes)
	pass


func set_daytime(_day: int, hour: int, minute: int) -> void:
	
	#region GameTIme based on Game Settings
	
	##radian_seconds = Time.get_time_dict_from_system()["second"] * (PI/30)
	
	radian_minutes = minute * (PI/30)
	radian_hours = hour * (PI/6) + radian_minutes / 12
	
	#mesh_hours.rotate_x(-radian_hours)
	#mesh_minutes.rotate_x(-radian_minutes)
	
	mesh_hours.set_rotation(Vector3(-radian_hours, 0, 0))
	mesh_minutes.set_rotation(Vector3(-radian_minutes, 0, 0))
	
	#mesh_hours.rotation = Vector3(radian_hours, 0, 0)
	#mesh_minutes.rotation = Vector3(radian_minutes, 0, 0)
	#mesh_seconds.rotation = Vector3(radian_seconds, 0, 0)
	
	#endregion
	pass
