extends Control

func set_drachma(value): 
	get_node("Label").set_text("$ "+str(value))

func _ready():
	set_drachma(PlayerStats.drachma)
	PlayerStats.connect("drachma_changed", self, "set_drachma")
