extends NinePatchRect

const ItemSlotClass = preload("res://Display/Inventory/ItemSlot.gd");
const ItemClass = preload("res://Display/Inventory/Item.gd");
var slotList = Array()
var displayingItem = null
var playerItems = {"Crystal": {
	"amount": 3, 
	"slot": null
	}
}

const ITEMMAP = {
	"Crystal": {
		"itemImg": preload("res://Display/Inventory/Crystal.png"), 
		"description": "dis is a crystal,\n Restores x2 health", 
		"effects": {
			"health": 2
		}
	}, 
	"Potion": {
		"itemImg": preload("res://Display/Inventory/Potion.png"), 
		"description": "*genji voice*: i need healing!\n Restores x1 health", 
		"effects": {
			"health": 1
		}
	}
}

func getFreeSlot(): 
	for slot in slotList: 
		if slot.empty: 
			return slot

func addItem(itemName): 
	if itemName in self.playerItems: 
		self.playerItems[itemName]["amount"] += 1
		self.playerItems[itemName]["slot"].subscript.set_text(str(self.playerItems[itemName]["amount"]))
	else:
		self.playerItems[itemName] = {"amount": 1}
		createNewItem(itemName)

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

func _physics_process(delta):
	if Input.is_action_just_pressed("toggle_inventory"):
		self.visible = !self.visible
		
func slot_gui_input(event: InputEvent, slot: ItemSlotClass): 
	if event is InputEventMouseButton: 
		if event.button_index == BUTTON_LEFT && event.pressed: 
			if (slot.get_child_count() > 0 && slot.get_child(0).itemName): 
				displayItemInfo(slot.get_child(0).itemName)
				
func displayItemInfo(itemName): 
	displayingItem = itemName
	var itemDescription = ITEMMAP[itemName]["description"]
	get_node("InfoContainer/ItemName").set_text("<" + itemName + ">")	
	get_node("InfoContainer/ItemDescription").set_text(itemDescription)
	
# Use item
func _on_Button_pressed(): 
	if !displayingItem or self.playerItems[displayingItem]["amount"] <= 0: 
		return
	var itemName = displayingItem
	print("Using item " + itemName)
	if "health" in ITEMMAP[itemName]["effects"]: 
		if PlayerStats.health == PlayerStats.max_health: 
#			get_parent().get_node("PopupDialog").message("Health already full!")
			PlayerStats.sendPopupMessage("Health already full!")
			return
		PlayerStats.health += ITEMMAP[itemName]["effects"]["health"]
		print("Increasing health by " + str(ITEMMAP[displayingItem]["effects"]["health"]))
		
	self.playerItems[itemName]["amount"] -= 1
	self.playerItems[itemName]["slot"].subscript.set_text(str(self.playerItems[itemName]["amount"]))