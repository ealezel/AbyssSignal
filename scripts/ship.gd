extends Node3D

signal openDoor

@onready var ship_animations: AnimationPlayer = $"Ship Model/Ship/Ship Animations"
@onready var water = get_node("%Water")

func _on_water_hider_body_entered(body):
	if body.is_in_group("player"):
		water.visible = false

func _on_water_hider_body_exited(body):
	if body.is_in_group("player"):
		water.visible = true


func _on_deck_ladder_body_entered(body):
	if body.is_in_group("player"):
		body.current_state = body.State.CLIMBING

func _on_deck_ladder_body_exited(body):
	if body.is_in_group("player"):
		body.current_state = body.State.WALKING
