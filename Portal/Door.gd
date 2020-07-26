extends Area2D

export(String, FILE, "*.tscn") var next_world

func _physics_process(delta):
	var bodies = get_overlapping_bodies()
	for body in bodies:
		if body.name == "Player" and Input.is_action_just_pressed("save"):
			get_tree().change_scene(next_world)
