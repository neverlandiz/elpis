extends "res://Stats.gd"

signal add_item_to_inventory(itemName)
signal display_popup_message(text)

func addItem(itemName): 
	emit_signal("add_item_to_inventory", itemName)
	
func sendPopupMessage(text): 
	emit_signal("display_popup_message", text)
