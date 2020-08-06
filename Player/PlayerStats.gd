extends "res://Stats/Stats.gd"

signal add_item_to_inventory(itemName)
signal add_item_to_merchant(itemNames)
signal display_popup_message(text)
signal drachma_changed(value)
signal get_item_quantity_in_inventory(itemName)

onready var drachma = 1000 setget set_drachma
var inConversation = false
var isOnFloor = true
var menuOpen = false
var tempItemQuantity = -1

func set_drachma(value):
	drachma = value
	emit_signal("drachma_changed", drachma)

func addItem(itemName, quantity): 
	emit_signal("add_item_to_inventory", itemName, quantity)
	
func getItemQuantity(itemName): 
	emit_signal("get_item_quantity_in_inventory", itemName)
	return tempItemQuantity

func loadMerchantWares(merchantName, itemNames): 
	emit_signal("add_item_to_merchant", merchantName, itemNames)
	
func sendPopupMessage(text): 
	emit_signal("display_popup_message", text)
