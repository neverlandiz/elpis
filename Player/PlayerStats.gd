extends "res://Stats.gd"

signal add_item_to_inventory(itemName)

func addItem(itemName): 
	emit_signal("add_item_to_inventory", itemName)
	
func addHealth(value): 
	.set_health(self.health+value)
	print("health increased")
