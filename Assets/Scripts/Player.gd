extends CharacterBody2D

# Variable Params
var speed = 100
@onready var spr = $AnimatedSprite2D
var bullet_shoot_speed = 0
var life = 100

# Constant params
const bulletPath = preload("res://Assets/Prefabs/bullets.tscn")
func _ready():
	spr.play("Idle")

func _physics_process(_delta):
	handleInputs()
	move_and_slide()


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
	var bullet = bulletPath.instantiate()
	get_parent().add_child(bullet)
	var _position = $Marker2D.global_position
	if bullet_shoot_pos <0:
		_position.x -= 28
	bullet.position = _position
	bullet.velocity = Vector2(bullet_shoot_speed,0)
	
