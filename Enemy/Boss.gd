extends KinematicBody2D

#const EnemyDeathEffect = preload("res://Effect/EnemyDeathEffect.tscn")
const HitEffect = preload("res://Effect/HitEffect.tscn")

export var ACCELERATION = 300
export var MAX_SPEED = 100
export var FRICTION = 0.25
export var AIR_RESISTANCE = 0.02
export var GRAVITY = 200
export var WANDER_TARGET_RANGE = 3

enum{
	IDLE,
	ATTACK,
	WANDER
}

var motion = Vector2.ZERO
var knockback = Vector2.ZERO

var state = ATTACK
var dir
var playerPos

onready var attackSprite = $Attack
onready var runSprite = $Run
onready var playerDetection = $PlayerDetection
#onready var softCollision = $SoftCollision
onready var wanderController = $WanderController
onready var hurtbox = $Hurtbox
onready var stats = $Stats
onready var animationPlayer = $AnimationPlayer


func _ready():
	state = pick_random_state([IDLE, WANDER])
	

func _physics_process(delta):
	knockback = knockback.move_toward(Vector2.ZERO, FRICTION * delta)
	knockback = move_and_slide(knockback)
	
	match state:
		IDLE:
			runSprite.hide()
			attackSprite.show()
			animationPlayer.play("Idle")
			motion = Vector2.ZERO
			seek_player()
			if wanderController.get_time_left() == 0:
				update_wander()
		WANDER:
			attackSprite.hide()
			runSprite.show()
			animationPlayer.play("Run")
			seek_player()
			if wanderController.get_time_left() == 0:
				update_wander()
			accelerate_towards_point(wanderController.target_position, delta)
			if global_position.distance_to(wanderController.target_position) <= WANDER_TARGET_RANGE:
				update_wander()
			
		ATTACK:
			runSprite.hide()
			attackSprite.show()
			var player = playerDetection.player
			if player != null:
				accelerate_towards_point(player.global_position, delta)
				attack()
			else:
				state = IDLE
				
	#if softCollision.is_colliding():
		#motion += softCollision.get_push_vector() * delta * 400
	
	motion.y += GRAVITY * delta
	motion = move_and_slide(motion, Vector2.UP)

func accelerate_towards_point(point, delta):
	var direction = global_position.direction_to(point)
	motion = motion.move_toward(direction * MAX_SPEED, ACCELERATION * delta)
	motion.y += GRAVITY * delta
	runSprite.flip_h = motion.x > 0

func attack():
	detectDir()
	if dir.x < 0:
		animationPlayer.play("AttackLeft")
	elif dir.x > 0:
		animationPlayer.play("AttackRight")

func update_wander():
	state = pick_random_state([IDLE, WANDER])
	wanderController.start_wander_timer(rand_range(1, 3))

func seek_player():
	if playerDetection.can_see_player():
		state = ATTACK

func pick_random_state(state_list):
	state_list.shuffle()
	return state_list.pop_front()

func create_hit_effect():
	var effect = HitEffect.instance()
	var main = get_tree().current_scene
	main.add_child(effect)
	effect.global_position = global_position

func detectDir():
	playerPos = playerDetection.player.position
	dir = playerPos - self.position



func _on_Hurtbox_area_entered(area):
	stats.health -= area.damage
	
	runSprite.show()
	attackSprite.hide()
	animationPlayer.play("HitEffect")
	motion = Vector2.ZERO
	
	create_hit_effect()
	
	
	detectDir()

	if dir.x > 0:
		knockback = Vector2.LEFT * 70
	elif dir.x < 0:
		knockback = Vector2.RIGHT * 70

func _on_Stats_no_health():
	queue_free() 
	#var enemyDeathEffect = EnemyDeathEffect.instance()
	#get_parent().add_child(enemyDeathEffect)
	#enemyDeathEffect.global_position = global_position


