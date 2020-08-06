extends Area2D

var itemName = "Potion"

func _on_Potion_body_entered(body):
	if body.name == "Player": 
		PlayerStats.addItem(itemName, 1)
		queue_free()
