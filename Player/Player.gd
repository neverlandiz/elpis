extends KinematicBody2D

const HitEffect = preload("res://Effect/HitEffectPlayer.tscn")
const PlayerDeathEffect = preload("res://Effect/PlayerDeathEffect.tscn")

export var ACCELERATION = 500
export var MAX_SPEED = 80
export var FRICTION = 0.25
export var AIR_RESISTANCE = 0.02
export var GRAVITY = 200
export var JUMP_FORCE = 125

enum{
	MOVE,
	ATTACK
}

var state = MOVE
var motion = Vector2.ZERO
var direction = Vector2.RIGHT
var stats = PlayerStats

onready var sprite = $Movements
onready var attackRightSprite = $AttackRight
onready var attackLeftSprite = $AttackLeft
onready var animationPlayer = $AnimationPlayer
onready var hurtbox = $Hurtbox
onready var swordHitbox = $HitboxPivot/SwordHitbox
onready var hurtAnimationPlayer = $HurtAnimationPlayer
onready var enemyDetection = $EnemyDetection

func _ready():
	stats.connect("no_health", self, "queue_free")
	attackRightSprite.hide()
	attackLeftSprite.hide()

func _physics_process(delta):
	if Input.is_action_just_pressed("ui_right"):
		direction = Vector2.RIGHT
	if Input.is_action_just_pressed("ui_left"):
		direction = Vector2.LEFT
	
	match state:
		MOVE:
			move(delta)
		ATTACK:
			attack()
			

func move(delta):
	sprite.show()
	attackRightSprite.hide()
	attackLeftSprite.hide()
	var x_input = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	
	if x_input != 0:
		animationPlayer.play("Run")
		motion.x += x_input * ACCELERATION * delta
		motion.x = clamp(motion.x, -MAX_SPEED, MAX_SPEED)
		sprite.flip_h = x_input < 0
	else:
		animationPlayer.play("Idle")
	
	motion.y += GRAVITY * delta
	
	if is_on_floor():
		if x_input == 0:
			motion.x = lerp(motion.x, 0, FRICTION)
			
		if Input.is_action_just_pressed("ui_up"):
			motion.y = -JUMP_FORCE
	else:
		
		if(motion.y < 0):
			animationPlayer.play("JumpUp")
		else:
			animationPlayer.play("JumpDown")
		
		if Input.is_action_just_released("ui_up") and motion.y < -JUMP_FORCE/2:
			motion.y = -JUMP_FORCE/2
			
		if x_input == 0:
			motion.x = lerp(motion.x, 0, AIR_RESISTANCE)
	
	motion = move_and_slide(motion, Vector2.UP)
	
	if Input.is_action_just_pressed("attack"):
		state = ATTACK

func attack():
	sprite.hide()
	
	if(direction == Vector2.RIGHT):
		attackLeftSprite.hide()
		attackRightSprite.show()
		animationPlayer.play("AttackRight")
	elif(direction == Vector2.LEFT):
		attackRightSprite.hide()
		attackLeftSprite.show()
		animationPlayer.play("AttackLeft")
	
	motion = Vector2.ZERO
	

func attack_animation_finished():
	state = MOVE

func create_hit_effect():
	var effect = HitEffect.instance()
	var main = get_tree().current_scene
	main.add_child(effect)
	effect.global_position = global_position

func _on_Hurtbox_area_entered(area):
	stats.health -= area.damage
	hurtbox.start_invincibility(0.6)
	create_hit_effect()
	
	var enemyPos = enemyDetection.enemy.position
	var dir = enemyPos - self.position
	motion.x -= dir.x * 90
	
	if(stats.health <= 0):
		var playerDeathEffect = PlayerDeathEffect.instance()
		get_parent().add_child(playerDeathEffect)
		playerDeathEffect.global_position = global_position

func _on_Hurtbox_invincibility_started():
	hurtAnimationPlayer.play("StartInvincibility")

func _on_Hurtbox_invincibility_ended():
	hurtAnimationPlayer.play("StopInvincibility")

