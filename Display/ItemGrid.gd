extends Node

const ItemSlotClass = preload("res://Display/Inventory/ItemSlot.gd");
const ItemClass = preload("res://Display/Inventory/Item.gd");
var slotList = Array()
var displayingItem = null

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

func _physics_process(delta):
	if Input.is_action_just_pressed("ui_cancel"):
		self.visible = false
		PlayerStats.menuOpen = false

func getFreeSlot(): 
	for slot in slotList: 
		if slot.empty: 
			return slot

func displayItemInfo(itemName): 
	displayingItem = itemName
	var itemDescription = ITEMMAP[itemName]["description"]
	get_node("InfoContainer/ItemName").set_text("<" + itemName + ">")	
	get_node("InfoContainer/ItemDescription").set_text(itemDescription)
	
func slot_gui_input(event: InputEvent, slot: ItemSlotClass): 
	if event is InputEventMouseButton: 
		if event.button_index == BUTTON_LEFT && event.pressed: 
			if (slot.get_child_count() > 0 && slot.get_child(0).itemName): 
				displayItemInfo(slot.get_child(0).itemName)
