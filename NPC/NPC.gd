extends Area2D

onready var animatedSprite = $AnimatedSprite
onready var playerDetection = $PlayerDetection
onready var label = $Label
onready var sprite = $Sprite

var dialogueIndex = 0
var playerStats = PlayerStats

const NPCMAP = {
	"npc1": {
		"dialogue": ["", "Hi!", "Bruh", "Bye"],
		"giveItem": ["Potion"]
	},
	"npc2": {
		"dialogue": ["", "...", "lol"],
		"giveItem": ["Potion"]
	}
}

func _ready():
	animatedSprite.flip_h = true

func renderDialogue():
	if self.dialogueIndex >= NPCMAP["npc1"]["dialogue"].size():
		self.dialogueIndex = 0
		playerStats.enterConversation = false
	label.set_text(str(NPCMAP["npc1"]["dialogue"][self.dialogueIndex]))

func _physics_process(_delta):
	if playerDetection.can_see_player():
		label.visible = true
		renderDialogue()
		if Input.is_action_just_pressed("ui_accept"):
			playerStats.enterConversation = true
			self.dialogueIndex += 1
			renderDialogue()
	else:
		self.dialogueIndex = 1
		label.visible = false





