extends "res://Display/ItemGrid.gd"

var playerItems = {
	"Crystal": {
		"amount": 3, 
	}
}

func addItem(itemName, quantity): 
	if itemName in self.playerItems: 
		self.playerItems[itemName]["amount"] += quantity
		self.playerItems[itemName]["slot"].subscript.set_text(str(self.playerItems[itemName]["amount"]))
	else:
		self.playerItems[itemName] = {"amount": quantity}
		createNewItem(itemName)
		
func getItemQuantity(itemName): 
	if itemName in self.playerItems: 
		PlayerStats.tempItemQuantity = self.playerItems[itemName]["amount"]
	else: 
		PlayerStats.tempItemQuantity = 0

func createNewItem(itemName):
	var item = ItemClass.new(itemName, ITEMMAP[itemName]["itemImg"])
	var slot = getFreeSlot()
	slot.fillSlot(item, self.playerItems[itemName]["amount"])
	self.playerItems[itemName]["slot"] = slot

func _ready():
	self.visible = false
	var slots = get_node("SlotsContainer/Slots")
	for i in range(10): 
		var slot = ItemSlotClass.new()
		slotList.append(slot)
		slots.add_child(slot)
		slot.connect("gui_input", self, "slot_gui_input", [slot])

	for itemName in self.playerItems:	# Load existing items for player
		createNewItem(itemName)
	
	PlayerStats.connect("add_item_to_inventory", self, "addItem")
	PlayerStats.connect("get_item_quantity_in_inventory", self, "getItemQuantity")

func _physics_process(delta):
	if Input.is_action_just_pressed("toggle_inventory"):
		self.visible = true
		PlayerStats.menuOpen = true

# Use item
func _on_Button_pressed(): 
	if !displayingItem or self.playerItems[displayingItem]["amount"] <= 0: 
		return
	var itemName = displayingItem
	print("Using item " + itemName)
	if "health" in ITEMMAP[itemName]["effects"]: 
		if PlayerStats.health == PlayerStats.max_health: 
			PlayerStats.sendPopupMessage("Health already full!")
			return
		PlayerStats.health += ITEMMAP[itemName]["effects"]["health"]
		print("Increasing health by " + str(ITEMMAP[displayingItem]["effects"]["health"]))
		
	self.playerItems[itemName]["amount"] -= 1
	self.playerItems[itemName]["slot"].subscript.set_text(str(self.playerItems[itemName]["amount"]))
