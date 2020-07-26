extends Area2D

var stats = PlayerStats

func _physics_process(delta):
	var bodies = get_overlapping_bodies()
	for body in bodies:
		if body.name == "Player" and Input.is_action_just_pressed("save"):
			stats.health = stats.max_health
			stats.sendPopupMessage("Health full!")
			print("Checkpoint")
