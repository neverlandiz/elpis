extends "res://Display/ItemGrid.gd"

func _ready():
	self.visible = false
	var slots = get_node("SlotsContainer/Slots")
	for i in range(10): 
		var slot = ItemSlotClass.new()
		slotList.append(slot)
		slots.add_child(slot)
		slot.connect("gui_input", self, "slot_gui_input", [slot])	
	PlayerStats.connect("add_item_to_merchant", self, "loadMerchantWares")

func createNewItem(itemName):
	var item = ItemClass.new(itemName, ITEMMAP[itemName]["itemImg"])
	var slot = getFreeSlot()
	slot.fillSlot(item, -1)	

func loadMerchantWares(merchantName, itemNames): 
	self.visible = true
	PlayerStats.menuOpen = true
	get_node("Title/Label").set_text(merchantName)	
	for itemName in itemNames:
		createNewItem(itemName)
		
func displayItemInfo(itemName): 
	displayingItem = itemName
	var itemDescription = ITEMMAP[itemName]["description"] + "\n (You own " + str(PlayerStats.getItemQuantity(itemName)) + ")"
	get_node("InfoContainer/ItemName").set_text("<" + itemName + ">")	
	get_node("InfoContainer/ItemDescription").set_text(itemDescription)
	get_node("InfoContainer/Button").set_text("Purchase for $" + str(ITEMMAP[itemName]["price"]))
	
# Purchase item
func _on_Button_pressed(): 
	if !displayingItem: 
		return
	var itemName = displayingItem
	if PlayerStats.drachma < ITEMMAP[itemName]["price"]: 
		PlayerStats.sendPopupMessage("You don't have enough drachma!")
	else: 
		PlayerStats.sendPopupMessage("Purchased item: " + itemName)
		PlayerStats.drachma -= ITEMMAP[itemName]["price"]
		PlayerStats.addItem(itemName, 1)
		displayItemInfo(itemName)
