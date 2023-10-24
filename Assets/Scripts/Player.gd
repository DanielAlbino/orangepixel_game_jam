extends CharacterBody2D

# Variable Params
var speed = 100
@onready var spr = $AnimatedSprite2D
@onready var lifeBar = $Camera2D/HPBar
@onready var bulletsBar = $Camera2D/bulletsBar
@onready var BulletCounter = $Camera2D/BulletCounter
@onready var HpCounter = $Camera2D/HpCounter
@onready var coinCounter = $Camera2D/StaticBody2D/coinCounter
@onready var hostCounter = $Camera2D/hostCounter
@onready var sound = $AudioStreamPlayer2D
@onready var light = $PointLight2D
@onready var msg = $messages

var lightTimer = 0.03
var bullet_shoot_speed = 0
var health = 100
var bullets = 100
var coinCount = 0
var hosts = 0
var hasDroppedBullets = false
var hasDroppedHealth = false
# Constant params
const bulletPath = preload("res://Assets/Prefabs/bullets.tscn")

func _ready():
	spr.play("Idle")
	msg.visible = false
	lifeBar.max_value = health
	bulletsBar.max_value = bullets
	HpCounter.text = str(health)

func _physics_process(_delta):
	if lightTimer <= 0:
		light.color = Color(255, 255, 255, 0.003)
	else:
		lightTimer -= 0.01
	hostCounter.text = str(hosts) + '/3'	
	
	if health > 0:
		handleInputs()
		move_and_slide()
		countCoins()
	else:
		spr.play("Death")
		
	if health >= 10:
		hasDroppedHealth = false
	if bullets >= 10:
		hasDroppedBullets = false
		
	lifeBar.value = health
	HpCounter.text = str(health)
	bulletsBar.value = bullets
	BulletCounter.text = str(bullets)
	if bullets == 0:
		msg.text = "I need ammo"
		msg.visible = true
	if health <= 5:
		msg.text = "I am dying"
		msg.visible = true

	if Input.is_action_pressed("buy_bullets") && coinCount > 0 && bullets == 0:
		extraBullets()
		
	if Input.is_action_pressed("buy_bullets") && coinCount > 0 && health <= 5 :
		extraHealth()

func countCoins():
	coinCounter.text = str(coinCount)

func handleInputs():
	if(Input.is_action_pressed("left")):
		velocity.x = -speed
		bullet_shoot_speed = -1
		spr.play("Run")
		spr.flip_h = true
		light.rotation = 89.5
	if(Input.is_action_pressed("right")):
		velocity.x = speed
		bullet_shoot_speed = 1
		spr.play("Run")
		spr.flip_h = false
		light.rotation = -89.5
	if(Input.is_action_pressed("up")):
		velocity.y = -speed
		spr.play("Run")
	if(Input.is_action_pressed("down")):
		velocity.y = speed
		spr.play("Run")
		
	if Input.is_action_just_pressed("shoot"):
		if bullets > 0:
			shoot(bullet_shoot_speed)
			
			
	if(
		Input.is_action_just_released("down") || 
		Input.is_action_just_released("up") || 
		Input.is_action_just_released("left") || 
		Input.is_action_just_released("right")
		): 
		velocity.x = 0
		velocity.y = 0
		spr.play("Idle")
		
func shoot(bullet_shoot_pos):
	bullets -= 1
	var bullet = bulletPath.instantiate()
	get_parent().add_child(bullet)
	sound.play()
	var _position = $Marker2D.global_position
	if bullet_shoot_pos < 0:
		_position.x -= 28
	bullet.position = _position
	bullet.velocity = Vector2(bullet_shoot_pos,0)
	
func extraBullets():
	bullets = 50
	if coinCount >= 10:
		coinCount -= 10
		bullets = 100
	else:
		bullets = coinCount * 10
		coinCount = 0
	BulletCounter.text = str(bullets)
	msg.visible = false

		
func extraHealth():
	if coinCount >= 10:
		coinCount -= 10
		lifeBar = 100
	else:
		lifeBar = coinCount * 10
		coinCount = 0
	HpCounter.text = str(lifeBar)
	msg.visible = false
	
func _on_area_2d_body_entered(body):
	if body.is_in_group("enemy_bullets"):
		health -= 5
		light.color = Color(255, 0, 0, 0.003)
		lightTimer = 0.03
		if health <= 0:
			lifeBar.value = 0
