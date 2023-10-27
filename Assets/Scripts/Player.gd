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
@onready var gameover = $Camera2D/GameOver

var lightTimer = 0.03
var bullet_shoot_speed = 0
var health = 100
var bullets = 100
var coinCount = 0
var hosts = 0
var deathHost = 0
var hasDroppedBullets = false
var hasDroppedHealth = false
var mousepos 
# Constant params
const bulletPath = preload("res://Assets/Prefabs/bullets.tscn")

func _ready():
	mousepos = get_viewport().get_mouse_position()
	self.position = $"../teleporter/safePoint".position
	$Pointer.look_at(get_global_mouse_position())
	$PointLight2D.rotation = $Pointer.rotation + (-89.5)
	spr.play("Idle")
	msg.visible = false
	lifeBar.max_value = health
	bulletsBar.max_value = bullets
	HpCounter.text = str(health)

func _physics_process(_delta):
	mousepos = get_global_mouse_position()
	$Pointer.look_at(get_global_mouse_position())
	$PointLight2D.rotation = $Pointer.rotation + (-89.5)
	
	if lightTimer <= 0:
		light.color = Color(255, 255, 255, 0.003)
	else:
		lightTimer -= 0.01
	hostCounter.text = str(hosts) + '/3'	
	lifeBar.value = health
	HpCounter.text = str(health)
	bulletsBar.value = bullets
	BulletCounter.text = str(bullets)
	if health > 0 && ( hosts != 3 || deathHost != 3  || deathHost + hosts != 3) :
		handleInputs()
		move_and_slide()
		countCoins()	
		if bullets == 0:
			msg.text = "I need ammo"
			msg.visible = true
		if health <= 5 && health > 0:
			msg.text = "I am dying"
			msg.visible = true
			
		if $Pointer/Marker.global_position <self.global_position:
			spr.flip_h = true
		else:
			spr.flip_h = false
			
		if Input.is_action_pressed("buy_bullets"):
			extraBullets()
			
		if Input.is_action_pressed("buy_health"):
			extraHealth()
	else:
		if health <= 0:
			health = 0
			spr.play("Death")
			_delta=0
		gameover.visible = !gameover.visible
	

func countCoins():
	coinCounter.text = str(coinCount)

func handleInputs():
	if(Input.is_action_pressed("left")):
		velocity.x = -speed
		bullet_shoot_speed = -1
		spr.play("Run")
		spr.flip_h = true
	if(Input.is_action_pressed("right")):
		velocity.x = speed
		bullet_shoot_speed = 1
		spr.play("Run")
		spr.flip_h = false
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
	if spr.flip_h:
		_position.x -= 28
	bullet.position = _position
	bullet.rotation = $Pointer.rotation
	bullet.velocity = (get_global_mouse_position() - bullet.position).normalized()
	
func extraBullets():
	if coinCount == 0 || coinCount < 5:
		return
	if bullets + coinCount * 10 >= 100:
		bullets = 100
	else:
		bullets += 50
	coinCount -= 5
	BulletCounter.text = str(bullets)
	msg.visible = false

		
func extraHealth():
	if coinCount == 0 || coinCount < 5:
		return
	if health + coinCount * 10 >= 100:
		health = 100
	else:
		health += 50
	coinCount -= 5
	HpCounter.text = str(health)
	msg.visible = false
	
func _on_area_2d_body_entered(body):
	if body.is_in_group("enemy_bullets") && health > 0:
		health -= 5
		light.color = Color(255, 0, 0, 0.003)
		lightTimer = 0.03
		if health <= 0:
			lifeBar.value = 0
