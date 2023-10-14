extends CharacterBody2D

var speed = 100
@onready var spr = $AnimatedSprite2D

func _ready():
	spr.play("Idle")

func _physics_process(delta):
	handleInputs()
	move_and_slide()


func handleInputs():
	if(Input.is_action_pressed("left")):
		velocity.x = -speed
		spr.play("Run")
		spr.flip_h = true
	if(Input.is_action_pressed("right")):
		velocity.x = speed
		spr.play("Run")
		spr.flip_h = false
	if(Input.is_action_pressed("up")):
		velocity.y = -speed
		spr.play("Run")
	if(Input.is_action_pressed("down")):
		velocity.y = speed
		spr.play("Run")
	if(
		Input.is_action_just_released("down") || 
		Input.is_action_just_released("up") || 
		Input.is_action_just_released("left") || 
		Input.is_action_just_released("right")
		): 
		velocity.x = 0
		velocity.y = 0
		spr.play("Idle")
