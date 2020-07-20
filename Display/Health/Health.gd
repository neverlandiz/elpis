extends Control

onready var healthFull = $HealthFull
onready var healthEmpty = $HealthEmpty

func set_health(value): 
	if healthFull: 
		healthFull.rect_size.x = value * 15

func set_max_health(value): 
	if healthEmpty: 
		healthEmpty.rect_size.x = value * 15

func _ready():
	set_health(PlayerStats.health)
	set_max_health(PlayerStats.max_health)
	PlayerStats.connect("health_changed", self, "set_health")
	PlayerStats.connect("max_health_changed", self, "set_max_health")	
