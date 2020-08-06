extends "res://Stats/Stats.gd"

signal add_item_to_inventory(itemName)
signal add_item_to_merchant(itemNames)
signal display_popup_message(text)

var inConversation = false

func addItem(itemName, quantity): 
	emit_signal("add_item_to_inventory", itemName, quantity)

func loadMerchantWares(merchantName, itemNames): 
	emit_signal("add_item_to_merchant", merchantName, itemNames)
	
func sendPopupMessage(text): 
	emit_signal("display_popup_message", text)
