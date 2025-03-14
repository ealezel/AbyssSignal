extends CharacterBody3D

@onready var camera = $Head/Eyes/Camera3D

@onready var head = $Head
@onready var eyes = $Head/Eyes
@onready var hand = $Hand

@onready var interact_checker = $"Head/Eyes/Interact Checker"
@onready var hint = $GUI/Hint

@onready var flashlight = $Hand/Flashlight
@onready var flashlight_click = $"Hand/Flashlight/Flashlight Click"

@onready var player_footsteps = $"Player Footsteps"
@onready var timer = $"Player Footsteps/Timer"

@onready var swimming_point = $"Swimming Point"
@onready var water = get_tree().get_first_node_in_group("water")

@onready var animation_player = get_tree().get_first_node_in_group("shipAnim")

var mouse_sens = 0.1

@export var walking_speed = 7
@export var diving_speed = 3
var temp = 0.0

var SPEED = 0
const JUMP_VELOCITY = 5
const GRAVITY = 9.8

var interactable = false
var door_object

enum State {
	WALKING,
	CLIMBING,
	SWIMMING
}
var current_state = State.WALKING

const head_bobbing_walking_speed = 8 #11.5
const head_bobbing_walking_intensity = 0.3 #0.15

var head_bobbing_vector = Vector2.ZERO
var head_bobbing_index = 0.0
var head_bobbing_current_intensity = 0.0

var lerp_speed = 10.0 #10.0

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _input(event):
	if event is InputEventMouseMotion:
		rotate_y(deg_to_rad(-event.relative.x * mouse_sens))
		head.rotate_x(deg_to_rad(-event.relative.y * mouse_sens))
		head.rotation.x = clamp(head.rotation.x, deg_to_rad(-80), deg_to_rad(80))
		
		hand.rotate_x(deg_to_rad(-event.relative.y * mouse_sens))
		hand.rotation.x = clamp(head.rotation.x, deg_to_rad(-80), deg_to_rad(80))
		
		if interact_checker.is_colliding():
			var target = interact_checker.get_collider()
			if target.is_in_group("door"):
				var targetObject = interact_checker.get_collider()
				door_object = targetObject
				door_object.door_name = targetObject.get_name()
				
				if (targetObject.is_open == true):
					hint.set_text("Close door (E)")
				else:
					hint.set_text("Open door (E)")
				
				hint.set_visible(true)
				interactable = true
			else:
				door_object = null
				hint.set_visible(false)
				interactable = false
		else:
			door_object = null
			hint.set_visible(false)
			interactable = false

func _physics_process(delta):
	#if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		#velocity.y = JUMP_VELOCITY
	
	var input_dir = Input.get_vector("Left", "Right", "Forward", "Backward")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	
	if is_on_floor():
		current_state = State.WALKING
	
	if is_on_floor() and velocity.length() != 0:
		if timer.time_left == 0:
			player_footsteps.pitch_scale = randf_range(0.8, 1)
			player_footsteps.play()
			timer.start(0.74)
	
	if not is_on_floor() and current_state == State.WALKING:
		velocity.y -= GRAVITY * delta

	if swimming_point.overlaps_area(water):
		if current_state != State.CLIMBING:
			current_state = State.SWIMMING
	else:
		if current_state != State.CLIMBING:
			current_state = State.WALKING

	if current_state == State.WALKING or current_state == State.CLIMBING:
		SPEED = walking_speed
		if direction:
			velocity.x = direction.x * SPEED
			velocity.z = direction.z * SPEED
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED)
			velocity.z = move_toward(velocity.z, 0, SPEED)
	
	if current_state == State.CLIMBING:
		direction = (transform.basis * Vector3(input_dir.x, input_dir.y,0)).normalized()
		velocity.y = 0
		
		if Input.is_action_pressed("Forward"):
			if head.rotation_degrees.x > -50:
				velocity.y = 1.0 * SPEED / 2
			else:
				velocity.y = -1.0 * SPEED / 2

		if Input.is_action_pressed("Backward"):
			velocity.y = -1.0 * SPEED / 2

	if current_state == State.SWIMMING:
		SPEED = diving_speed
		velocity.y = lerp(velocity.y, 0.0, delta * (SPEED /2.0))
		if direction:
			velocity.x = direction.x * SPEED	
			velocity.z = direction.z * SPEED
			velocity.y = head.rotation.x * SPEED
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED)
			velocity.z = move_toward(velocity.z, 0, SPEED)

	move_and_slide()

#region Flashlight
	if Input.is_action_just_pressed("Flashlight"):
		if flashlight.visible == true:
			flashlight.visible = false
			flashlight_click.stop()
			flashlight_click.set_pitch_scale(0.75)
			flashlight_click.play()
		else:
			flashlight.visible = true
			flashlight_click.stop()
			flashlight_click.set_pitch_scale(0.8)
			flashlight_click.play()
#endregion

#region HeadBob
	head_bobbing_current_intensity = head_bobbing_walking_intensity
	head_bobbing_index += head_bobbing_walking_speed * delta 
	
	if is_on_floor() && input_dir != Vector2.ZERO:
		head_bobbing_vector.y = sin(head_bobbing_index)
		head_bobbing_vector.x = sin(head_bobbing_index/2)+0.5
	
		eyes.position.y = lerp(eyes.position.y, head_bobbing_vector.y * (head_bobbing_current_intensity / 2.0), delta * lerp_speed)
		eyes.position.x = lerp(eyes.position.x, head_bobbing_vector.x * head_bobbing_current_intensity, delta * lerp_speed)
	else:
		eyes.position.y = lerp(eyes.position.y, 0.0, delta * lerp_speed)
		eyes.position.x = lerp(eyes.position.x, 0.0, delta * lerp_speed)

#endregion

#region Interact
	if Input.is_action_just_pressed("Interact"):
		if door_object != null:
			if (door_object.is_open == true):
				door_object.is_open = false
				hint.set_visible(false)
				animation_player.play(door_object.door_name + "_close")
			else:
				door_object.is_open = true
				hint.set_visible(false)
				animation_player.play(door_object.door_name + "_open")
#endregion
