extends Area2D

onready var animatedSprite = $AnimatedSprite
onready var playerDetection = $PlayerDetection
onready var label = $Label
onready var sprite = $Sprite

const NPCMAP = {
	"npc1": {
		"dialogue": ["", "Hi!", "Bruh", "Bye"],
		"role": "talk",
	},
	"npc2": {
		"dialogue": ["", "I'm giving you...", "...", ".....", "two potions and a crystal!"],
		"role": "delivery",
		"items": {"Potion": 2, "Crystal": 1}, 
	},
	"npc3": {
		"dialogue": ["", "Helloooo", "I sell stuff", "pls buy"],
		"role": "merchant",
		"items": ["Potion", "Crystal"], 
	},  
}

var dialogueIndex = 0
var playerStats = PlayerStats

func _ready():
	animatedSprite.flip_h = true

func renderDialogue():
	# End of dialogue
	if self.dialogueIndex >= NPCMAP[self.name]["dialogue"].size():
		self.dialogueIndex = 0
		playerStats.inConversation = false
		if NPCMAP[self.name]["role"] == "delivery": 
			var popupText = ""
			var formatStr = "Gained x%s %s!\n"
			for itemName in NPCMAP[self.name]["items"]:
				var quantity = NPCMAP[self.name]["items"][itemName]
				PlayerStats.addItem(itemName, quantity)
				popupText += formatStr % [quantity, itemName]
			PlayerStats.sendPopupMessage(popupText)
		elif NPCMAP[self.name]["role"] == "merchant": 
			playerStats.loadMerchantWares(self.name, NPCMAP[self.name]["items"])
	label.set_text(str(NPCMAP[self.name]["dialogue"][self.dialogueIndex]))

func _physics_process(_delta):
	if playerDetection.can_see_player():
		label.visible = true
		renderDialogue()
		if Input.is_action_just_pressed("ui_accept"):
			playerStats.inConversation = true
			self.dialogueIndex += 1
			renderDialogue()
	else:
		self.dialogueIndex = 1
		label.visible = false





