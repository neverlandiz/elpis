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
		"price": 10,
		"effects": {
			"health": 2
		}
	}, 
	"Potion": {
		"itemImg": preload("res://Display/Inventory/Potion.png"), 
		"description": "*genji voice*: i need healing!\n Restores x1 health", 
		"price": 6, 
		"effects": {
			"health": 1
		}
	}
}

func getFreeSlot(): 
	for slot in slotList: 
		if slot.empty: 
			return slot

func createNewItem(itemName):
	var item = ItemClass.new(itemName, ITEMMAP[itemName]["itemImg"])
	var slot = getFreeSlot()
	slot.fillSlot(item, -1)

func _ready():
	self.visible = false
	var slots = get_node("SlotsContainer/Slots")
	for i in range(10): 
		var slot = ItemSlotClass.new()
		slotList.append(slot)
		slots.add_child(slot)
		slot.connect("gui_input", self, "slot_gui_input", [slot])
	
	PlayerStats.connect("add_item_to_merchant", self, "loadMerchantWares")
	
func _physics_process(delta):
	if Input.is_action_just_pressed("ui_cancel"):
		self.visible = false

func loadMerchantWares(merchantName, itemNames): 
	self.visible = true
	get_node("Title/Label").set_text(merchantName)	
	for itemName in itemNames:
		createNewItem(itemName)
		
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
	if !displayingItem: 
		return
	var itemName = displayingItem
	print("Purchased item " + itemName)
	# Deduct money + Not enough money 

	PlayerStats.addItem(itemName, 1)
