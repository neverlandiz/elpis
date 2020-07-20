extends "res://Stats.gd"

signal add_item_to_inventory(itemName)

func addItem(itemName): 
	emit_signal("add_item_to_inventory", itemName)
