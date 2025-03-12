extends MeshInstance3D

@export var tilt = 10
@export var tilt_speed = 0.1

var angle = Vector3(randf_range(-tilt, tilt), 0, randf_range(-tilt, tilt))
var backward = false

func _physics_process(delta):
	global_rotation_degrees = global_rotation_degrees.lerp(angle, delta * tilt_speed)

func _on_timer_timeout():	
	if backward == false:
		angle = Vector3(randf_range(-tilt, tilt), 0, randf_range(-tilt, tilt))
		backward = true
	else:
		angle = -angle
		backward = false
